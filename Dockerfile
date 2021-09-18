# UBUNTU_VER can be overwritten on build with --build-arg
# Pinned version tag from https://hub.docker.com/_/ubuntu
ARG UBUNTU_VER=21.10

############################################################
## STAGE ONE - BERKELEY DATABASE
## Compile Berkeley Database
## https://bitzuma.com/posts/compile-bitcoin-core-from-source-on-ubuntu/
## https://github.com/alexfoster/bitcoin-dockerfile/blob/master/Dockerfile
##############################################################
FROM ubuntu:$UBUNTU_VER AS berkeley-database

## Disable prompts during package install
ENV DEBIAN_FRONTEND=noninteractive 
ENV BERKELEY_VERSION=db-4.8.30.NC
ENV BERKELEY_PREFIX=/build
ARG BERKELEY_KEY=12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef
ARG TARGETARCH

RUN apt-get update && apt-get install -y \
        build-essential wget

RUN wget http://download.oracle.com/berkeley-db/${BERKELEY_VERSION}.tar.gz

# TODO: Check download
#RUN RUN sha256sum --ignore-missing --check ${DB_KEY}} | grep -q "db-4.8.30.NC.tar.gz: OK" || { echo "Checksum of release not in asc file"; exit 1; }

RUN tar -xzf "${BERKELEY_VERSION}.tar.gz"
RUN mkdir -p ${BERKELEY_PREFIX}
RUN sed s/__atomic_compare_exchange/__atomic_compare_exchange_db/g -i ${BERKELEY_VERSION}/dbinc/atomic.h
WORKDIR /${BERKELEY_VERSION}/build_unix/
RUN ../dist/configure \
    --enable-cxx \
    --disable-shared  \
    --with-pic \
    --prefix=${BERKELEY_PREFIX} \
    --build=${TARGETARCH}-unknown-linux-gnu
RUN make install
RUN rm -rf ${BERKELEY_PREFIX}/docs

############################################################
## STAGE ONE
## Build bitcoin-core
##############################################################
FROM ubuntu:$UBUNTU_VER AS bitcoin-core

## Disable prompts during package install
ENV DEBIAN_FRONTEND=noninteractive 

## Get latest version from > https://github.com/bitcoin/bitcoin/releases & https://bitcoincore.org/en/releases/
## Confirm key used to sign > https://bitcoincore.org/en/download/
## Can be overwritten on with --build-arg at build time
## TODO: update version to 22
ARG BTC_CORE_VER=0.21.1
# ARG BTC_SOURCE_BRANCH=0.21
ARG BTC_PREFIX=/build
ARG BTC_KEY=01EA5486DE18A882D4C2684590C8019E36C2E964

COPY --from=berkeley-database ${BERKELEY_PREFIX} ${BERKELEY_PREFIX}

## INSTALL BUILD DEPENDENCIES
## https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md#ubuntu--debian
## Needed to change to libboost-all-dev to compile from src.tar.gz
RUN apt-get update && apt-get install -y \
        build-essential libtool autotools-dev automake pkg-config python3 \
        libevent-dev libboost-dev libboost-system-dev libboost-filesystem-dev libboost-test-dev \
        libsqlite3-dev \
        libminiupnpc-dev libnatpmp-dev \
        libzmq3-dev \
        systemtap-sdt-dev \
        wget \
        && rm -rf /var/lib/apt/lists/*

## DOWNLOAD SOURCE AND SIGNATURE
## https://bitcoincore.org/en/download/#verify-your-download
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BTC_CORE_VER}/bitcoin-${BTC_CORE_VER}.tar.gz && \
    wget https://bitcoincore.org/bin/bitcoin-core-${BTC_CORE_VER}/SHA256SUMS.asc

## Alternatively, clone from github
# RUN git clone --branch ${BTC_SOURCE_BRANCH} https://github.com/bitcoin/bitcoin.git

## VERIFY DOWNLOAD
## https://bitcoincore.org/en/download/#verify-your-download

    ## Verify that the checksum of the release file is listed in the checksums file
RUN sha256sum --ignore-missing --check SHA256SUMS.asc | grep -q "bitcoin-${BTC_CORE_VER}.tar.gz: OK" || { echo "Checksum of release not in asc file"; exit 1; } && \
    ## Obtain a copy of the release signing key
    gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys $BTC_KEY && \
    ## Verify that the checksums file is PGP signed by the release signing key
    gpg --verify SHA256SUMS.asc 2>&1 | grep -q "gpg: Good signature" || { echo "Couldn't verify signature!"; exit 1; } && \
    gpg --verify SHA256SUMS.asc 2>&1 | grep -q "Primary key fingerprint: 01EA 5486 DE18 A882 D4C2  6845 90C8 019E 36C2 E96" || { echo "Finger print no good!"; exit 1; }

## COMPILE BITCOIN-CORE
## https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md#ubuntu--debian
RUN tar -xzf "bitcoin-${BTC_CORE_VER}.tar.gz"
WORKDIR /bitcoin-${BTC_CORE_VER}

## If downloading via git clone
# WORKDIR /bitcoin 

RUN export BDB_PREFIX=${BERKELEY_PREFIX}
## Generate headers
RUN ./autogen.sh 
## Configure build
RUN ./configure \
        #CPPFLAGS="-I${BERKELEYDB_PREFIX}/include/ -O2" LDFLAGS="-L${BERKELEYDB_PREFIX}/lib/ -static-libstdc++" \
        #CPPFLAGS="-I${BERKELEYDB_PREFIX}/include/ -O2" LDFLAGS="-L${BERKELEYDB_PREFIX}/lib/" \
        #CPPFLAGS=-I`ls -d /opt/db*`/include/ LDFLAGS=-L`ls -d /opt/db*`/lib/ \
        CPPFLAGS=-I/build/include/ LDFLAGS=-L/build/lib/ \
        --prefix=/build \
        --without-gui \
        --disable-tests \
        --disable-bench \
        --disable-ccache \
        --enable-hardening
## Compile build
RUN make
    ## Strip debug symbols
RUN strip \
        src/bitcoin-cli \
        src/bitcoin-tx \
        src/bitcoind
    ## Install
RUN make install

############################################################
## STAGE TWO
## Pull it all together
##############################################################
FROM ubuntu:$UBUNTU_VER AS release

## Disable prompts during package install
ENV DEBIAN_FRONTEND=noninteractive
## Bitcoind data directory
ENV DATA_DIR=/bitcoin
ENV TOR_DIR=/tor

## Don't use root
ENV USER=nonroot
ENV GROUP=${USER}
ENV PUID=10000
ENV PGID=10001

## Non-root user for security purposes.
RUN addgroup --gid ${PGID} --system  ${GROUP} && \
    adduser  --uid ${PUID} --system --ingroup ${GROUP} --home /home/${USER} ${USER}

## INSTALL PACKAGES
## bind-tools is needed for DNS resolution to work in *some* Docker networks
## Tini allows us to avoid several Docker edge cases, see https://github.com/krallin/tini.
RUN apt-get update && apt-get install -y \
        libevent-dev libboost-all-dev libminiupnpc-dev libnatpmp-dev libzmq3-dev libsqlite3-dev \
        bash \
        curl \
        tini \
        python3 \
        dnsutils \
        nano \
        && rm -rf /var/lib/apt/lists/*

## CREATE DIRECTORIES
RUN mkdir -p ${DATA_DIR}/ && chown -R ${USER}:${GROUP} ${DATA_DIR}/ && chmod 700 ${DATA_DIR}/ && \
    mkdir -p ${TOR_DIR}/ && chown -R ${USER}:${GROUP} ${TOR_DIR}/ && chmod 700 ${TOR_DIR}/

## COPY FILES TO DOCKER IMAGE
## Copy compiled bitcoin daemon from bitcoin-builder
COPY --from=bitcoin-core /usr/local/ /usr/local/

## Copy file for generating authentication string setting
COPY --chown=${USER}:${GROUP} --chmod=700 rpcauth.py /usr/local/share

## Copy entrypoint bash script for templating config
COPY --chown=${USER}:${GROUP} --chmod=700 entrypoint.sh /usr/local/bin

## Copy healthcheck bash script to image
COPY --chown=${USER}:${GROUP} --chmod=700 healthcheck.sh /usr/local/bin

## Copy torrc and examples to tmp tor. Entrypoint will copy across to bind-volume
COPY --chown=${USER}:${GROUP} --chmod=u+rw ./bitcoin.conf* /tmp

## Available environmental variables
ENV CONFIG_OVERWRITE="false" \
    LOG_CONFIG="false" \
    ALERT_NOTIFY= \
    ASSUME_VALID= \
    BLOCK_FILTER_INDEX= \
    BLOCK_NOTIFY= \
    BLOCK_RECONSTRUCTION_EXTRA_TXN= \
    BLOCKS_DIR= \
    BLOCKS_ONLY= \
    CONF= \
    DAEMON= \
    # DATA_DIR = \ # This is set by the image above so lets not double up
    DB_CACHE= \
    DEBUG_LOG_FILE= \
    INCLUDE_CONF= \
    LOAD_BLOCK= \
    MAX_MEMPOOL= \
    MAX_ORPHAN_TX= \
    MEMPOOL_EXPIRY= \
    PAR= \
    PERSIST_MEMPOOL= \
    PID= \
    PRUNE= \
    REINDEX= \
    REINDEX_CHAINSTATE= \
    SETTINGS= \
    STARTUP_NOTIFY= \
    SYS_PERMS= \
    TX_INDEX= \
    ADD_NODE= \
    ASMAP= \
    BAN_TIME= \
    BIND= \
    CONNECT= \
    DISCOVER= \
    DNS= \
    DNS_SEED= \
    EXTERNAL_IP= \
    FORCE_DNS_SEED= \
    LISTEN= \
    LISTEN_ONION= \
    MAX_CONNECTIONS= \
    MAX_RECEIVE_BUFFER= \
    MAX_SEND_BUFFER= \
    MAX_TIME_ADJUSTMENT= \
    MAX_UPLOAD_TARGET= \
    NETWORK_ACTIVE= \
    ONION= \
    ONLY_NET= \
    PEER_BLOCK_FILTERS= \
    PEER_BLOOM_FILTERS= \
    PERMIT_BARE_MULTISIG= \
    PORT= \
    PROXY= \
    PROXY_RANDOMIZE= \
    SEED_NODE= \
    TIMEOUT= \
    TOR_CONTROL= \
    TOR_PASSWORD= \
    UPNP= \
    WHITE_BIND= \
    WHITE_LIST= \
    DEBUG= \
    DEBUG_EXCLUDE= \
    LOG_IPS= \
    LOG_THREAD_NAMES= \
    LOG_TIMESTAMPS= \
    PRINT_TO_CONSOLE= \
    SHRINK_DEBUG_FILE= \
    UA_COMMENT= \
    CHAIN= \
    SIGNET= \
    SIGNET_CHALLENGE= \
    SIGNET_SEED_NODE= \
    TEST_NET= \
    BYTES_PER_SIGOP= \
    DATA_CARRIER= \
    DATA_CARRIER_SIZE= \
    MIN_RELAY_TX_FEE= \
    WHITE_LIST_FORCE_RELAY= \
    WHITE_LIST_RELAY= \
    BLOCK_MAX_WEIGHT= \
    BLOCK_MIN_TX_FEE= \
    REST= \
    RPC_ALLOW_IP= \
    RPC_BIND= \
    RPC_COOKIE_FILE= \
    # RPC_PASSWORD= \ # RPCPASSWORD & RPCUSER are used to generate RPCAUTH
    RPC_PORT= \
    RPC_SERIAL_VERSION= \
    RPC_THREADS= \
    # RPC_USER= \ # RPCPASSWORD & RPCUSER are used to generate RPCAUTH
    RPC_WHITE_LIST= \
    RPC_WHITE_LIST_DEFAULT= \
    SERVER= \
    ZMQ_PUB_HASH_TX= \
    ZMQ_PUB_HASH_BLOCK= \
    ZMQ_PUB_RAW_BLOCK= \
    ZMQ_PUB_RAW_TX= \
    ZMQ_PUB_SEQUENCE=

## Label the docker image
LABEL maintainer="Barney Buffet <BarneyBuffet@tutanota.com>"
LABEL name="Bitcoin core (daemon)"
LABEL version=${BTC_CORE_VER}
LABEL description="A docker image for bitcoin core daemon"
LABEL license="GNU"
LABEL url="https://bitcoincore.org/"
LABEL vcs-url="https://github.com/BarneyBuffet"  

USER ${USER}:${GROUP}
WORKDIR ${DATA_DIR}
EXPOSE 8333/tcp 8334/tcp
ENTRYPOINT ["/usr/bin/tini", "--", "entrypoint.sh"]
CMD bitcoind