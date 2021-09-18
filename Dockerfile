# Pinned version tag from https://hub.docker.com/_/ubuntu, can be overwritten on build with --build-arg
ARG UBUNTU_VER=21.10

############################################################
## BUILD BITCOIN-CORE
##############################################################
FROM ubuntu:$UBUNTU_VER AS bitcoin-core

## Disable prompts during package install
ENV DEBIAN_FRONTEND=noninteractive 

## IMAGE VARIABLES
## Get latest version from > https://bitcoincore.org/bin/, can be overwritten on build with --build-arg
## TODO: update version to 22
ARG BTC_CORE_VER=0.21.1
ARG BTC_KEY=01EA5486DE18A882D4C2684590C8019E36C2E964

## INSTALL BUILD DEPENDENCIES
## https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md#ubuntu--debian
## Needed to change to libboost-all-dev to compile from src.tar.gz
RUN apt-get update && apt-get install -y \
        build-essential libtool autotools-dev automake pkg-config python3 \
        libevent-dev libboost-all-dev libboost-test-dev \
        libsqlite3-dev \
        libminiupnpc-dev libnatpmp-dev \
        libzmq3-dev \
        systemtap-sdt-dev \
        wget \
        && rm -rf /var/lib/apt/lists/*

## DOWNLOAD SOURCE, SIGNATURE & VERIFY
## https://bitcoincore.org/en/download/#verify-your-download
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BTC_CORE_VER}/bitcoin-${BTC_CORE_VER}.tar.gz &&\
    wget https://bitcoincore.org/bin/bitcoin-core-${BTC_CORE_VER}/SHA256SUMS.asc &&\
    ## Verify that the checksum of the release file is listed in the checksums file
    sha256sum --ignore-missing --check SHA256SUMS.asc | grep -q "bitcoin-${BTC_CORE_VER}.tar.gz: OK" || { echo "Checksum of release not in asc file"; exit 1; } && \
    ## Obtain a copy of the release signing key
    gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys $BTC_KEY && \
    ## Verify that the checksums file is PGP signed by the release signing key
    gpg --verify SHA256SUMS.asc 2>&1 | grep -q "gpg: Good signature" || { echo "Couldn't verify signature!"; exit 1; } && \
    gpg --verify SHA256SUMS.asc 2>&1 | grep -q "Primary key fingerprint: 01EA 5486 DE18 A882 D4C2  6845 90C8 019E 36C2 E96" || { echo "Finger print no good!"; exit 1; }

## EXTRACT BITCOIN-CORE SOURCE
## https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md#ubuntu--debian
RUN tar -xzf "bitcoin-${BTC_CORE_VER}.tar.gz"
WORKDIR /bitcoin-${BTC_CORE_VER}

## BUILD AND INSTALL LIBDB4.8 (BERKELEY DATABASE)
ARG BERKELEY_INSTALL_FILE=./contrib/install_db4.sh
RUN set -x &&\
    sed -i.old 's/make install/make libdb_cxx-4.8.a libdb-4.8.a \&\& make install_lib install_include/' ${BERKELEY_INSTALL_FILE} &&\
    chmod 755 ${BERKELEY_INSTALL_FILE} &&\
    ${BERKELEY_INSTALL_FILE} `pwd` --prefix="/usr/local"

## COMPILE BITCOIN CORE
## Generate headers
RUN ./autogen.sh &&\
    ## Configure build
    ./configure CXXFLAGS="-g -O0" CFLAGS="-g -O0" \
        # --prefix=/build \
        --without-gui \
        --disable-tests \
        --disable-bench \
        --disable-cache \
        --enable-hardening &&\
    ## Compile build
    make &&\
    ## Strip debug symbols
    strip \
        src/bitcoin-cli \
        src/bitcoin-tx \
        src/bitcoind &&\
    ## Install
    make install

############################################################
## STAGE TWO
## Build release image
##############################################################
FROM ubuntu:$UBUNTU_VER AS release

    ## Disable prompts during package install
ENV DEBIAN_FRONTEND=noninteractive \
    ## Bitcoind data directory
    DATA_DIR=/bitcoin \
    ## Tor data directory
    TOR_DIR=/tor \
    ## Container user
    USER=nonroot \
    GROUP=nonroot \
    PUID=10000 \
    PGID=10001

## Non-root user for security purposes.
RUN addgroup --gid ${PGID} --system  ${GROUP} && \
    adduser  --uid ${PUID} --system --ingroup ${GROUP} --home /home/${USER} ${USER}

## INSTALL PACKAGES
## Tini allows us to avoid several Docker edge cases, see https://github.com/krallin/tini.
## dnsutils is needed for DNS resolution to work in *some* Docker networks
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

## Copy health check bash script to image
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
    REINDEX_CHAIN_STATE= \
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
    RPC_PASSWORD= \ 
    RPC_PORT= \
    RPC_SERIAL_VERSION= \
    RPC_THREADS= \
    RPC_USER= \ 
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
LABEL description="A docker image for a bitcoin core daemon"
LABEL license="MIT"
LABEL url="https://bitcoincore.org/"
LABEL vcs-url="https://BarneyBuffet.github.io/docker-bitcoin-core/"

USER ${USER}:${GROUP}
WORKDIR ${DATA_DIR}
EXPOSE 8333/tcp 8334/tcp
ENTRYPOINT ["/usr/bin/tini", "--", "entrypoint.sh"]
CMD bitcoind