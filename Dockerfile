# UBUNTU_VER can be overwritten on build with --build-arg
# Pinned version tag from https://hub.docker.com/_/ubuntu
ARG UBUNTU_VER=21.10

############################################################
## STAGE ONE
## Build bitcoin-core
##############################################################
FROM ubuntu:$UBUNTU_VER AS bitcoind-builder

## Disable prompts during package install
ENV DEBIAN_FRONTEND=noninteractive 

## Get latest version from > https://github.com/bitcoin/bitcoin/releases & https://bitcoincore.org/en/releases/
## Confirm key used to sign > https://bitcoincore.org/en/download/
## Can be overwritten on with --build-arg at build time
ARG BTC_CORE_VER=0.21.1
# ARG BTC_SOURCE_BRANCH=0.21
ARG BTC_PREFIX=/opt/bitcoin-${BTC_CORE_VER}
ARG BTC_KEY=01EA5486DE18A882D4C2684590C8019E36C2E964

## INSTALL BUILD DEPENDENCIES
## https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md#ubuntu--debian
## Needed to change to libboost-all-dev to compile from src.tar.gz
RUN apt-get update && apt-get install -y \
        build-essential libtool autotools-dev automake pkg-config python3 \
        libevent-dev libboost-all-dev libminiupnpc-dev libnatpmp-dev libzmq3-dev \
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

## Generate headers
RUN ./autogen.sh && \
    ## Configure build
    ./configure \
        --disable-wallet \
        --without-gui \
        --disable-tests \
        --disable-bench \
        --disable-ccache \
        --enable-hardening && \
    ## Compile build
    make && \
    ## Strip debug symbols
    strip \
        src/bitcoin-cli \
        src/bitcoin-tx \
        src/bitcoind && \
    ## Install
    make install

############################################################
## STAGE TWO
## Pull it all together
##############################################################
FROM ubuntu:$UBUNTU_VER

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
        libevent-dev libboost-all-dev libminiupnpc-dev libnatpmp-dev libzmq3-dev \
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
COPY --from=bitcoind-builder /usr/local/ /usr/local/

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
    DB_CACHE= \
    DEBUG_LOG_FILE= \
    INCLUDE_CONF= \
    LOAD_BLOCK= \
    MAX_MEM_POOL= \
    MAX_ORPHAN_TX= \
    MEM_POOL_EXPIRY= \
    PAR= \
    PERSISTMEMPOOL= \
    PID= \
    PRUNE= \
    REINDEX= \
    REINDEX_CHAINSTATE= \
    SETTINGS= \
    STARTUPNOTIFY= \
    SYSPERMS= \
    TXINDEX= \
    ADDNODE= \
    ASMAP= \
    BANTIME= \
    BIND= \
    CONNECT= \
    DISCOVER= \
    DNS= \
    DNSSEED= \
    EXTERNALIP= \
    FORCEDNSSEED= \
    LISTEN= \
    LISTENONION= \
    MAXCONNECTIONS= \
    MAXRECEIVEBUFFER= \
    MAXSENDBUFFER= \
    MAXTIMEADJUSTMENT= \
    MAXUPLOADTARGET= \
    NETWORKACTIVE= \
    ONION= \
    ONLYNET= \
    PEERBLOCKFILTERS= \
    PEERBLOOMFILTERS= \
    PERMITBAREMULTISIG= \
    PORT= \
    PROXY= \
    PROXYRANDOMIZE= \
    SEEDNODE= \
    TIMEOUT= \
    TORCONTROL= \
    TORPASSWORD= \
    UPNP= \
    WHITEBIND= \
    WHITELIST= \
    DEBUG= \
    DEBUGEXCLUDE= \
    HELP_DEBUG= \
    LOGIPS= \
    LOGTHREADNAMES= \
    LOGTIMESTAMPS= \
    PRINTTOCONSOLE= \
    SHRINKDEBUGFILE= \
    UACOMMENT= \
    CHAIN= \
    SIGNET= \
    SIGNETCHALLENGE= \
    SIGNETSEEDNODE= \
    TESTNET= \
    BYTESPERSIGOP= \
    DATACARRIER= \
    DATACARRIERSIZE= \
    MINRELAYTXFEE= \
    WHITELISTFORCERELAY= \
    WHITELISTRELAY= \
    BLOCKMAXWEIGHT= \
    BLOCKMINTXFEE= \
    REST= \
    RPCALLOWIP= \
    # RPCAUTH= \ # RPCPASSWORD & RPCUSER are used to generate RPCAUTH
    RPCBIND= \
    RPCCOOKIEFILE= \
    RPCPASSWORD= \
    RPCPORT= \
    RPCSERIALVERSION= \
    RPCTHREADS= \
    RPCUSER= \
    RPCWHITELIST= \
    RPCWHITELISTDEFAULT= \
    SERVER= \
    ZMQPUBHASHTX= \
    ZMQPUBHASHBLOCK= \
    ZMQPUBRAWBLOCK= \
    ZMQPUBRAWTX= \
    ZMQPUBSEQUENCE=

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