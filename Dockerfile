# Pinned version tag from https://hub.docker.com/_/ubuntu, can be overwritten on build with --build-arg
ARG UBUNTU_VER=21.10

############################################################
## BUILD BITCOIN-CORE RELEASE
##############################################################
FROM ubuntu:$UBUNTU_VER AS bitcoin-core-builder

## Disable prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

## INSTALL DEPENDENCIES
## Tini allows us to avoid several Docker edge cases, see https://github.com/krallin/tini.
## dnsutils is needed for DNS resolution to work in *some* Docker networks
RUN apt-get update && apt-get install -y \
        gnupg wget  \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## BITCOIN CORE VARIABLES
## Get latest version from > https://bitcoincore.org/bin/, can be overwritten on build with --build-arg
ARG TARGETPLATFORM
ARG BTC_CORE_VER=22.0
# Bitcoin keys (all)
ENV KEYS 71A3B16735405025D447E8F274810B012346C9A6 \
    01EA5486DE18A882D4C2684590C8019E36C2E964 \
    0CCBAAFD76A2ECE2CCD3141DE2FFD5B1D88CA97D \
    152812300785C96444D3334D17565732E08E5E41 \
    0AD83877C1F0CD1EE9BD660AD7CC770B81FD22A8 \
    590B7292695AFFA5B672CBB2E13FC145CD3F4304 \
    28F5900B1BB5D1A4B6B6D1A9ED357015286A333D \
    CFB16E21C950F67FA95E558F2EEB9F5CC09526C1 \
    6E01EEC9656903B0542B8F1003DB6322267C373B \
    D1DBF2C4B96F2DEBF4C16654410108112E7EA81F \
    9D3CC86A72F8494342EA5FD10A41BDC3F4FAFF1C \
    74E2DEF5D77260B98BC19438099BAD163C70FBFA \
    637DB1E23370F84AFF88CCE03152347D07DA627C \
    82921A4B88FD454B7EB8CE3C796C4109063D4EAF
# keys to fetch from ubuntu keyserver
ENV KEYS1 71A3B16735405025D447E8F274810B012346C9A6 \
    01EA5486DE18A882D4C2684590C8019E36C2E964 \
    0CCBAAFD76A2ECE2CCD3141DE2FFD5B1D88CA97D \
    152812300785C96444D3334D17565732E08E5E41 \
    0AD83877C1F0CD1EE9BD660AD7CC770B81FD22A8 \
    590B7292695AFFA5B672CBB2E13FC145CD3F4304 \
    28F5900B1BB5D1A4B6B6D1A9ED357015286A333D \
    CFB16E21C950F67FA95E558F2EEB9F5CC09526C1 \
    6E01EEC9656903B0542B8F1003DB6322267C373B \
    D1DBF2C4B96F2DEBF4C16654410108112E7EA81F \
    9D3CC86A72F8494342EA5FD10A41BDC3F4FAFF1C \
    74E2DEF5D77260B98BC19438099BAD163C70FBFA
# keys to fetch from keys.openpgp.org
ENV KEYS2 637DB1E23370F84AFF88CCE03152347D07DA627C \
    82921A4B88FD454B7EB8CE3C796C4109063D4EAF


## DOWNLOAD BINARY, SIGNATURE, VERIFY & EXTRACT
## https://bitcoincore.org/en/download/#verify-your-download
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then export TARGETPLATFORM=x86_64-linux-gnu; fi &&\
    if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then export TARGETPLATFORM=aarch64-linux-gnu; fi &&\
    if [ "${TARGETPLATFORM}" = "linux/arm/v7" ]; then export TARGETPLATFORM=arm-linux-gnueabihf; fi &&\
    ## Download binary
    wget https://bitcoincore.org/bin/bitcoin-core-${BTC_CORE_VER}/bitcoin-${BTC_CORE_VER}-${TARGETPLATFORM}.tar.gz &&\
    wget https://bitcoincore.org/bin/bitcoin-core-${BTC_CORE_VER}/SHA256SUMS.asc &&\
    wget https://bitcoincore.org/bin/bitcoin-core-${BTC_CORE_VER}/SHA256SUMS &&\
    ## Get PGP keys from server. TODO: confirm verification process
    timeout 32s gpg  --keyserver keyserver.ubuntu.com  --recv-keys $KEYS1 &&\
    timeout 32s gpg  --keyserver keys.openpgp.org  --recv-keys $KEYS2 &&\
    ## Verify that hashes are signed with the previously imported key
    gpg --verify SHA256SUMS.asc SHA256SUMS &&\
    ## Verify that downloaded source-code archive matches exactly the hash that's provided
    grep " bitcoin-${BTC_CORE_VER}-${TARGETPLATFORM}.tar.gz\$" SHA256SUMS | sha256sum -c - &&\
    ## Extract binaries and remove GUI 
    tar -xzf "bitcoin-${BTC_CORE_VER}-${TARGETPLATFORM}.tar.gz" && \
    mv /bitcoin-${BTC_CORE_VER} /bitcoin-core &&\
    rm /bitcoin-core/bin/bitcoin-qt
    

############################################################
## BUILD BITCOIN-CORE RELEASE
##############################################################
FROM ubuntu:$UBUNTU_VER AS release

## Disable prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

## INSTALL DEPENDENCIES
## Tini allows us to avoid several Docker edge cases, see https://github.com/krallin/tini.
## dnsutils is needed for DNS resolution to work in *some* Docker networks
RUN apt-get update && apt-get install -y \
        python3 bash curl \
        tini dnsutils gosu \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## CREATE NON-ROOT USER FOR SECURITY
RUN addgroup --gid 1001 --system nonroot && \
    adduser  --uid 1000 --system --ingroup nonroot --home /home/nonroot nonroot

## BITCOIN CORE AND TOR DATA DIRECTORY
ENV DATA_DIR=/bitcoin \
    TOR_DIR=/tor

# ## CREATE DATA DIRECTORIES
RUN mkdir -p ${DATA_DIR}/ && chown -R nonroot:nonroot ${DATA_DIR}/ && chmod go=rX,u=rwX ${DATA_DIR}/ && \
    mkdir -p ${TOR_DIR}/ && chown -R nonroot:nonroot ${TOR_DIR}/ && chmod go=rX,u=rwX ${TOR_DIR}/

## COPY FILES TO DOCKER IMAGE
## Copy  bitcoin daemon from bitcoin-core-builder
COPY --from=bitcoin-core-builder /bitcoin-core/ /usr/local/

## Copy file for generating authentication string setting
COPY --chown=nonroot:nonroot --chmod=go+rX,u+rwX rpcauth.py /usr/local/share

## Copy entrypoint bash script for templating config
COPY --chown=nonroot:nonroot --chmod=go+rX,u+rwX entrypoint.sh /usr/local/bin

## Copy health check bash script to image
COPY --chown=nonroot:nonroot --chmod=go+rX,u+rwX healthcheck.sh /usr/local/bin

## Copy torrc and examples to tmp tor. Entrypoint will copy across to bind-volume
COPY --chown=nonroot:nonroot --chmod=u+rw ./bitcoin.conf* /tmp

## Available environmental variables
ENV PUID= \
    PGID= \
    CONFIG_OVERWRITE="false" \
    LOG_CONFIG="false" \
    ALERT_NOTIFY= \
    ASSUME_VALID= \
    BLOCK_FILTER_INDEX= \
    BLOCK_NOTIFY= \
    BLOCK_RECONSTRUCTION_EXTRA_TXN= \
    BLOCKS_DIR= \
    BLOCKS_ONLY= \
    COIN_STATS_INDEX= \
    CONF= \
    DAEMON= \
    DAEMON_WAIT= \
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
    FIXED_SEEDS= \
    FORCE_DNS_SEED= \
    I2P_ACCEPT_INCOMING= \
    I2P_SAM= \
    LISTEN= \
    LISTEN_ONION= \
    MAX_CONNECTIONS= \
    MAX_RECEIVE_BUFFER= \
    MAX_SEND_BUFFER= \
    MAX_TIME_ADJUSTMENT= \
    NAT_PMP= \
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
    ADDRESS_TYPE= \
    AVOID_PARTIAL_SPENDS= \
    CHANGE_TYPE= \
    DISABLE_WALLET= \
    DISCARD_FEE= \
    FALLBACK_FEE= \
    KEY_POOL= \
    MAX_APS_FEE= \
    MIN_TX_FEE= \
    MAX_TX_FEE= \
    PAY_TX_FEE= \
    RESCAN= \
    SIGNER= \
    SPEND_ZERO_CONF_CHANGE= \
    TX_CONFIRM_TARGET= \
    WALLET= \
    WALLET_BROADCAST= \
    WALLET_DIR= \
    WALLET_NOTIFY= \
    WALLET_RBF= \
    ZMQ_PUB_HASH_BLOCK= \
    ZMQ_PUB_HASH_BLOCK_HWM= \
    ZMQ_PUB_HASH_TX= \
    ZMQ_PUB_HASH_TX_HWM= \
    ZMQ_PUB_RAW_BLOCK= \
    ZMQ_PUB_RAW_BLOCK_HWM= \
    ZMQ_PUB_RAW_TX= \
    ZMQ_PUB_RAW_TX_HWM= \
    ZMQ_PUB_SEQUENCE= \
    ZMQ_PUB_SEQUENCE_HWM= \
    DEBUG= \
    DEBUG_EXCLUDE= \
    LOG_IPS= \
    LOG_SOURCE_LOCATIONS= \
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
    SERVER= 

HEALTHCHECK --interval=60s --timeout=15s --start-period=20s \
            CMD bash /usr/local/healthcheck.sh \
            || exit 1

## Label the docker image
LABEL maintainer="Barney Buffet <BarneyBuffet@tutanota.com>"
LABEL name="Bitcoin core (daemon)"
LABEL version=${BTC_CORE_VER}
LABEL description="A docker image for a bitcoin core daemon"
LABEL license="MIT"
LABEL url="https://bitcoincore.org/"
LABEL vcs-url="https://BarneyBuffet.github.io/docker-bitcoin-core/"

VOLUME ["${DATA_DIR}"]
WORKDIR ${DATA_DIR}
EXPOSE 8332 8333 18332 18333 18443 18444 38333 38332
ENTRYPOINT ["/usr/bin/tini", "--", "entrypoint.sh"]
CMD bitcoind