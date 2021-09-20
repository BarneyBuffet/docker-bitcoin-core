#!/bin/bash
set -eo pipefail

BITCOIN_CONFIG_FILE=${DATA_DIR}/bitcoin.conf

##############################################################################
## Display bitcoin.conf in log
##############################################################################
echo_config(){
  echo -e "\\n====================================- START ${BITCOIN_CONFIG_FILE} -====================================\\n"
  cat $BITCOIN_CONFIG_FILE
  echo -e "\\n=====================================- END ${BITCOIN_CONFIG_FILE} -=====================================\\n"
}

##############################################################################
## Template config based on env
##############################################################################
template_config(){

  if [[ -n "${ALERT_NOTIFY}" ]]; then
    sed -i "/#alertnotify=.*/c\alertnotify=${ALERT_NOTIFY}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ASSUME_VALID}" ]]; then
    sed -i "/#assumevalid=.*/c\assumevalid=${ASSUME_VALID}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BLOCK_FILTER_INDEX}" ]]; then
    sed -i "/#blockfilterindex=.*/c\blockfilterindex=${BLOCK_FILTER_INDEX}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BLOCK_NOTIFY}" ]]; then
    sed -i "/#blocknotify=.*/c\blocknotify=${BLOCK_NOTIFY}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BLOCK_RECONSTRUCTION_EXTRA_TXN}" ]]; then
    sed -i "/#blockreconstructionextratxn=.*/c\blockreconstructionextratxn=${BLOCK_RECONSTRUCTION_EXTRA_TXN}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BLOCKS_DIR}" ]]; then
    sed -i "/#blocksdir=.*/c\blocksdir=${BLOCKS_DIR}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BLOCKS_ONLY}" ]]; then
    if $BLOCKS_ONLY; then _flag=1 ; else _flag=0; fi
    sed -i "/#blocksonly=.*/c\blocksonly=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${COIN_STATS_INDEX}" ]]; then
    if $COIN_STATS_INDEX; then _flag=1 ; else _flag=0; fi
    sed -i "/#coinstatsindex=.*/c\coinstatsindex=${_flag}" $BITCOIN_CONFIG_FILE
  fi
  
  if [[ -n "${CONF}" ]]; then
    sed -i "/#conf=.*/c\conf=${CONF}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DAEMON}" ]]; then
    if $DAEMON; then _flag=1 ; else _flag=0; fi
    sed -i "/#daemon=.*/c\daemon=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DAEMON_WAIT}" ]]; then
    if $DAEMON_WAIT; then _flag=1 ; else _flag=0; fi
    sed -i "/#daemonwait=.*/c\daemonwait=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DATA_DIR}" ]]; then
    sed -i "/#datadir=.*/c\datadir=${DATA_DIR}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DB_CACHE}" ]]; then
    sed -i "/#dbcache=.*/c\dbcache=${DB_CACHE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DEBUG_LOG_FILE}" ]]; then
    sed -i "/#debuglogfile=.*/c\dbcache=${DEBUG_LOG_FILE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${INCLUDE_CONF}" ]]; then
    sed -i "/#includeconf=.*/c\includeconf=${INCLUDE_CONF}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${LOAD_BLOCK}" ]]; then
    sed -i "/#loadblock=.*/c\loadblock=${LOAD_BLOCK}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${MAX_MEMPOOL}" ]]; then
    sed -i "/#maxmempool=.*/c\maxmempool=${MAX_MEMPOOL}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${MAX_ORPHAN_TX}" ]]; then
    sed -i "/#maxorphantx=.*/c\maxorphantx=${MAX_ORPHAN_TX}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${MEMPOOL_EXPIRY}" ]]; then
    sed -i "/#mempoolexpiry=.*/c\mempoolexpiry=${MEMPOOL_EXPIRY}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PAR}" ]]; then
    sed -i "/#par=.*/c\par=${PAR}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PERSIST_MEMPOOL}" ]]; then
    if $PERSIST_MEMPOOL; then _flag=1 ; else _flag=0; fi
    sed -i "/#persistmempool=.*/c\persistmempool=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PID}" ]]; then
    sed -i "/#pid=.*/c\pid=${PID}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PRUNE}" ]]; then
    sed -i "/#prune=.*/c\prune=${PRUNE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${REINDEX}" ]]; then
    if $REINDEX; then _flag=1 ; else _flag=0; fi
    sed -i "/#reindex=.*/c\reindex=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${REINDEX_CHAIN_STATE}" ]]; then
    if $REINDEX_CHAIN_STATE; then _flag=1 ; else _flag=0; fi
    sed -i "/#reindex-chainstate=.*/c\reindex-chainstate=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SETTINGS}" ]]; then
    sed -i "/#settings=.*/c\settings=${SETTINGS}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${STARTUP_NOTIFY}" ]]; then
    sed -i "/#startupnotify=.*/c\startupnotify=${STARTUP_NOTIFY}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SYS_PERMS}" ]]; then
    if $SYS_PERMS; then _flag=1 ; else _flag=0; fi
    sed -i "/#sysperms=.*/c\sysperms=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${TX_INDEX}" ]]; then
    if $TX_INDEX; then _flag=1 ; else _flag=0; fi
    sed -i "/#txindex=.*/c\txindex=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ADD_NODE}" ]]; then
    ## Convert string into an array
    nodes=(${ADD_NODE//,/ })

    ## Parse through each item
    for node in ${nodes[@]}; do
      sed -i "/#addnode=<ip>/a\addnode=${node}" $BITCOIN_CONFIG_FILE
    done
  fi
 
  if [[ -n "${ASMAP}" ]]; then
    sed -i "/#asmap=.*/c\asmap=${ASMAP}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BAN_TIME}" ]]; then
    sed -i "/#bantime=.*/c\bantime=${BAN_TIME}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BIND}" ]]; then
    ## Convert string into an array
    nics=(${BIND//,/ })

    ## Parse through each item
    for nic in ${nics[@]}; do
      sed -i "/#bind=.*/c\bind=${nic}" $BITCOIN_CONFIG_FILE
    done
  fi

  if [[ -n "${CONNECT}" ]]; then
    ## Convert string into an array
    nodes=(${CONNECT//,/ })

    ## Parse through each item
    for node in ${nodes[@]}; do
      sed -i "/#connect=<ip>/a\connect=${node}" $BITCOIN_CONFIG_FILE
    done
  fi

  if [[ -n "${DISCOVER}" ]]; then
    if $DISCOVER; then _flag=1 ; else _flag=0; fi
    sed -i "/#discover=.*/c\discover=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DNS}" ]]; then
    if $DNS; then _flag=1 ; else _flag=0; fi
    sed -i "/#dns=.*/c\dns=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DNS_SEED}" ]]; then
    if $DNS_SEED; then _flag=1 ; else _flag=0; fi
    sed -i "/#dnsseed=.*/c\dnsseed=${_flag}" $BITCOIN_CONFIG_FILE
  fi
 
  if [[ -n "${EXTERNAL_IP}" ]]; then
    sed -i "/#externalip=.*/c\externalip=${EXTERNAL_IP}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${FIXED_SEEDS}" ]]; then
    if $FIXED_SEEDS; then _flag=1 ; else _flag=0; fi
    sed -i "/#fixedseeds=.*/c\fixedseeds=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${FORCE_DNS_SEED}" ]]; then
    if $FORCE_DNS_SEED; then _flag=1 ; else _flag=0; fi
    sed -i "/#forcednsseed=.*/c\forcednsseed=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${I2P_ACCEPT_INCOMING}" ]]; then
    if $I2P_ACCEPT_INCOMING; then _flag=1 ; else _flag=0; fi
    sed -i "/#i2pacceptincoming=.*/c\i2pacceptincoming=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${I2P_SAM}" ]]; then
    ## Convert string into an array
    peers=(${I2P_SAM//,/ })

    ## Parse through each item
    for peer in ${peers[@]}; do
      sed -i "/#i2psam=<ip:port>/a\i2psam=${peer}" $BITCOIN_CONFIG_FILE
    done
  fi
 
  if [[ -n "${LISTEN}" ]]; then
    if $LISTEN; then _flag=1 ; else _flag=0; fi
    sed -i "/#listen=.*/c\listen=${_flag}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${LISTEN_ONION}" ]]; then
    if $LISTEN_ONION; then _flag=1 ; else _flag=0; fi
    sed -i "/#listenonion=.*/c\listenonion=${_flag}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${MAX_CONNECTIONS}" ]]; then
    sed -i "/#maxconnections=.*/c\maxconnections=${MAX_CONNECTIONS}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${MAX_RECEIVE_BUFFER}" ]]; then
    sed -i "/#maxreceivebuffer=.*/c\maxreceivebuffer=${MAX_RECEIVE_BUFFER}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${MAX_SEND_BUFFER}" ]]; then
    sed -i "/#maxsendbuffer=.*/c\maxsendbuffer=${MAX_SEND_BUFFER}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${MAX_TIME_ADJUSTMENT}" ]]; then
    sed -i "/#maxtimeadjustment=.*/c\maxtimeadjustment=${MAX_TIME_ADJUSTMENT}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${MAX_UPLOAD_TARGET}" ]]; then
    sed -i "/#maxuploadtarget=.*/c\maxuploadtarget=${MAX_UPLOAD_TARGET}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${NAT_PMP}" ]]; then
    if $NAT_PMP; then _flag=1 ; else _flag=0; fi
    sed -i "/#natpmp=.*/c\natpmp=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${NETWORK_ACTIVE}" ]]; then
    if $NETWORK_ACTIVE; then _flag=1 ; else _flag=0; fi
    sed -i "/#networkactive=.*/c\networkactive=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ONION}" ]]; then
    sed -i "/#onion=.*/c\onion=${ONION}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ONLY_NET}" ]]; then
    ## Convert string into an array
    nets=(${ONLY_NET//,/ })

    ## Parse through each item
    for net in ${nets[@]}; do
      sed -i "/#onlynet=<net>/a\onlynet=${net}" $BITCOIN_CONFIG_FILE
    done
  fi

  if [[ -n "${PEER_BLOCK_FILTERS}" ]]; then
    if $PEER_BLOCK_FILTERS; then _flag=1 ; else _flag=0; fi
    sed -i "/#peerblockfilters=.*/c\peerblockfilters=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PEER_BLOOM_FILTERS}" ]]; then
    if $PEER_BLOOM_FILTERS; then _flag=1 ; else _flag=0; fi
    sed -i "/#peerbloomfilters=.*/c\peerbloomfilters=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PERMIT_BARE_MULTISIG}" ]]; then
    if $PERMIT_BARE_MULTISIG; then _flag=1 ; else _flag=0; fi
    sed -i "/#permitbaremultisig=.*/c\permitbaremultisig=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PORT}" ]]; then
    sed -i "/#port=.*/c\port=${PORT}" $BITCOIN_CONFIG_FILE
  fi
 
  if [[ -n "${PROXY}" ]]; then
    sed -i "/#proxy=.*/c\proxy=${PROXY}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PROXY_RANDOMIZE}" ]]; then
    if $PROXY_RANDOMIZE; then _flag=1 ; else _flag=0; fi
    sed -i "/#proxyrandomize=.*/c\proxyrandomize=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SEED_NODE}" ]]; then
    ## Convert string into an array
    nodes=(${SEED_NODE//,/ })

    ## Parse through each item
    for node in ${nodes[@]}; do
      sed -i "/#seednode=<ip>/a\seednode=${node}" $BITCOIN_CONFIG_FILE
    done
  fi

  if [[ -n "${TIMEOUT}" ]]; then
    sed -i "/#timeout=.*/c\timeout=${TIMEOUT}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${TOR_CONTROL}" ]]; then
    sed -i "/#torcontrol=.*/c\torcontrol=${TOR_CONTROL}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${TOR_PASSWORD}" ]]; then
    sed -i "/#torpassword=.*/c\torpassword=${TOR_PASSWORD}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${UPNP}" ]]; then
    if $UPNP; then _flag=1 ; else _flag=0; fi
    sed -i "/#upnp=.*/c\upnp=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${WHITE_BIND}" ]]; then
    ## Convert string into an array
    list=(${WHITE_BIND//,/ })

    ## Parse through each item
    for item in ${list[@]}; do
      sed -i "/#whitebind=.*/a\whitebind=${item}" $BITCOIN_CONFIG_FILE
    done
  fi
 
  if [[ -n "${WHITE_LIST}" ]]; then
    ## Convert string into an array
    list=(${WHITE_LIST//,/ })

    ## Parse through each item
    for item in ${list[@]}; do
      sed -i "/#whitelist=.*/a\whitelist=${item}" $BITCOIN_CONFIG_FILE
    done
  fi

  if [[ -n "${ADDRESS_TYPE}" ]]; then
    sed -i "/#addresstype=.*/c\addresstype=${ADDRESS_TYPE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${AVOID_PARTIAL_SPENDS}" ]]; then
    if $AVOID_PARTIAL_SPENDS; then _flag=1 ; else _flag=0; fi
    sed -i "/#avoidpartialspends=.*/c\avoidpartialspends=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${CHANGE_TYPE}" ]]; then
    sed -i "/#changetype=.*/c\changetype=${CHANGE_TYPE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DISABLE_WALLET}" ]]; then
    if $DISABLE_WALLET; then _flag=1 ; else _flag=0; fi
    sed -i "/#disablewallet=.*/c\disablewallet=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DISCARD_FEE}" ]]; then
    sed -i "/#discardfee=.*/c\discardfee=${DISCARD_FEE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${FALLBACK_FEE}" ]]; then
    sed -i "/#fallbackfee=.*/c\fallbackfee=${FALLBACK_FEE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${KEY_POOL}" ]]; then
    sed -i "/#keypool=.*/c\keypool=${KEY_POOL}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${MAX_APS_FEE}" ]]; then
    sed -i "/#maxapsfee=.*/c\maxapsfee=${MAX_APS_FEE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${MIN_TX_FEE}" ]]; then
    sed -i "/#mintxfee=.*/c\mintxfee=${MIN_TX_FEE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${MAX_TX_FEE}" ]]; then
    sed -i "/#maxtxfee=.*/c\maxtxfee=${MAX_TX_FEE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PAY_TX_FEE}" ]]; then
    sed -i "/#paytxfee=.*/c\paytxfee=${PAY_TX_FEE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${RESCAN}" ]]; then
    if $RESCAN; then _flag=1 ; else _flag=0; fi
    sed -i "/#rescan=.*/c\rescan=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SIGNER}" ]]; then
    sed -i "/#signer=.*/c\signer=${SIGNER}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SPEND_ZERO_CONF_CHANGE}" ]]; then
    if $SPEND_ZERO_CONF_CHANGE; then _flag=1 ; else _flag=0; fi
    sed -i "/#spendzeroconfchange=.*/c\spendzeroconfchange=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${TX_CONFIRM_TARGET}" ]]; then
    sed -i "/#txconfirmtarget=.*/c\txconfirmtarget=${TX_CONFIRM_TARGET}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${WALLET}" ]]; then
    sed -i "/#wallet=.*/c\wallet=${WALLET}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${WALLET_BROADCAST}" ]]; then
    if $WALLET_BROADCAST; then _flag=1 ; else _flag=0; fi
    sed -i "/#walletbroadcast=.*/c\walletbroadcast=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${WALLET_DIR}" ]]; then
    sed -i "/#walletdir=.*/c\walletdir=${WALLET_DIR}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${WALLET_NOTIFY}" ]]; then
    sed -i "/#walletnotify=.*/c\walletnotify=${WALLET_NOTIFY}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${WALLET_RBF}" ]]; then
    if $WALLET_RBF; then _flag=1 ; else _flag=0; fi
    sed -i "/#walletrbf=.*/c\walletrbf=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ZMQ_PUB_HASH_BLOCK}" ]]; then
    sed -i "/#zmqpubhashblock=.*/c\zmqpubhashblock=${ZMQ_PUB_HASH_BLOCK}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ZMQ_PUB_HASH_BLOCK_HWM}" ]]; then
    sed -i "/#zmqpubhashblockhwm=.*/c\zmqpubhashblockhwm=${ZMQ_PUB_HASH_BLOCK_HWM}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ZMQ_PUB_HASH_TX_HWM}" ]]; then
    sed -i "/#zmqpubhashtxhwm=.*/c\zmqpubhashtxhwm=${ZMQ_PUB_HASH_TX_HWM}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ZMQ_PUB_HASH_TX}" ]]; then
    sed -i "/#zmqpubhashtx=.*/c\zmqpubhashtx=${ZMQ_PUB_HASH_TX}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ZMQ_PUB_RAW_BLOCK}" ]]; then
    sed -i "/#zmqpubrawblock=.*/c\zmqpubrawblock=${ZMQ_PUB_RAW_BLOCK}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ZMQ_PUB_RAW_BLOCK_HWM}" ]]; then
    sed -i "/#zmqpubrawblockhwm=.*/c\zmqpubrawblockhwm=${ZMQ_PUB_RAW_BLOCK_HWM}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ZMQ_PUB_RAW_TX}" ]]; then
    sed -i "/#zmqpubrawtx=.*/c\zmqpubrawtx=${ZMQ_PUB_RAW_TX}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ZMQ_PUB_RAW_TX_HWM}" ]]; then
    sed -i "/#zmqpubrawtxhwm=.*/c\zmqpubrawtxhwm=${ZMQ_PUB_RAW_TX_HWM}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ZMQ_PUB_SEQUENCE}" ]]; then
    sed -i "/#zmqpubsequence=.*/c\zmqpubsequence=${ZMQ_PUB_SEQUENCE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ZMQ_PUB_SEQUENCE_HWM}" ]]; then
    sed -i "/#zmqpubsequencehwm=.*/c\zmqpubsequencehwm=${ZMQ_PUB_SEQUENCE_HWM}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DEBUG}" ]]; then
    ## Convert string to array comma separated
    categories=(${DEBUG//,/ })

    ## Parse through categories
    for cat in ${categories[@]}; do 
      sed -i "/#debug=.*/a\debug=${cat}" $BITCOIN_CONFIG_FILE
    done
  fi

  if [[ -n "${DEBUG_EXCLUDE}" ]]; then
    ## Convert string to array comma separated
    categories=(${DEBUG_EXCLUDE//,/ })

    ## Parse through categories
    for cat in ${categories[@]}; do 
      sed -i "/#debugexclude=.*/a\debugexclude=${cat}" $BITCOIN_CONFIG_FILE
    done
  fi

  # if [[ -n "${HELP_DEBUG}" ]]; then
  #   sed -i "/#help-debug/c\help-debug" $BITCOIN_CONFIG_FILE
  # fi

  if [[ -n "${LOG_IPS}" ]]; then
    if $LOG_IPS; then _flag=1 ; else _flag=0; fi
    sed -i "/#logips=.*/c\logips=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${LOG_SOURCE_LOCATIONS}" ]]; then
    if $LOG_SOURCE_LOCATIONS; then _flag=1 ; else _flag=0; fi
    sed -i "/#logsourcelocations=.*/c\logsourcelocations=${_flag}" $BITCOIN_CONFIG_FILE
  fi
 
  # if [[ -n "${LOG_THREAD_NAMES}" ]]; then
  #   if $LOG_THREAD_NAMES; then _flag=1 ; else _flag=0; fi
  #   sed -i "/#logthreadnames=.*/c\logthreadnames=${_flag}" $BITCOIN_CONFIG_FILE
  # fi

  if [[ -n "${LOG_TIMESTAMPS}" ]]; then
    if $LOG_TIMESTAMPS; then _flag=1 ; else _flag=0; fi
    sed -i "/#logtimestamps=.*/c\logtimestamps=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PRINT_TO_CONSOLE}" ]]; then
    if $PRINT_TO_CONSOLE; then _flag=1 ; else _flag=0; fi
    sed -i "/#printtoconsole=.*/c\printtoconsole=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SHRINK_DEBUG_FILE}" ]]; then
    if $SHRINK_DEBUG_FILE; then _flag=1 ; else _flag=0; fi
    sed -i "/#shrinkdebugfile=.*/c\shrinkdebugfile=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${UA_COMMENT}" ]]; then
    sed -i "/#uacomment=.*/c\uacomment=${UA_COMMENT}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${CHAIN}" ]]; then
    sed -i "/#chain=.*/c\chain=${CHAIN}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SIGNET}" ]]; then
    if $SIGNET; then _flag=1 ; else _flag=0; fi
    sed -i "/#signet=.*/c\signet=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SIGNET_CHALLENGE}" ]]; then
    if $SIGNET_CHALLENGE; then _flag=1 ; else _flag=0; fi
    sed -i "/#signetchallenge/c\signetchallenge=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SIGNET_SEED_NODE}" ]]; then
    ## Convert string into an array
    nodes=(${SIGNET_SEED_NODE//,/ })

    ## Parse through each item
    for node in ${nodes[@]}; do
      sed -i "/#signetseednode=<address:port>/a\signetseednode=${node}" $BITCOIN_CONFIG_FILE
    done
  fi

  if [[ -n "${TEST_NET}" ]]; then
    if $TEST_NET; then _flag=1 ; else _flag=0; fi
    sed -i "/#testnet=.*/c\testnet=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BYTES_PER_SIGOP}" ]]; then
    sed -i "/#bytespersigop=.*/c\bytespersigop=${BYTES_PER_SIGOP}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DATA_CARRIER}" ]]; then
    if $DATA_CARRIER; then _flag=1 ; else _flag=0; fi
    sed -i "/#datacarrier=.*/c\datacarrier=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DATA_CARRIER_SIZE}" ]]; then
    sed -i "/#datacarriersize=.*/c\datacarriersize=${DATA_CARRIER_SIZE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${MIN_RELAY_TX_FEE}" ]]; then
    sed -i "/#minrelaytxfee=.*/c\minrelaytxfee=${MIN_RELAY_TX_FEE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${WHITE_LIST_FORCE_RELAY}" ]]; then
    if $WHITE_LIST_FORCE_RELAY; then _flag=1 ; else _flag=0; fi
    sed -i "/#whitelistforcerelay=.*/c\whitelistforcerelay=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${WHITE_LIST_RELAY}" ]]; then
    if $WHITE_LIST_RELAY; then _flag=1 ; else _flag=0; fi
    sed -i "/#whitelistrelay=.*/c\whitelistrelay=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BLOCK_MAX_WEIGHT}" ]]; then
    sed -i "/#blockmaxweight=.*/c\blockmaxweight=${BLOCK_MAX_WEIGHT}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BLOCK_MIN_TX_FEE}" ]]; then
    sed -i "/#blockmintxfee=.*/c\blockmintxfee=${BLOCK_MIN_TX_FEE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${REST}" ]]; then
    if $REST; then _flag=1 ; else _flag=0; fi
    sed -i "/#rest=.*/c\rest=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${RPC_ALLOW_IP}" ]]; then
    ## Convert string into an array
    ips=(${RPC_ALLOW_IP//,/ })

    ## Parse through each item
    for ip in ${ips[@]}; do
      sed -i "/#rpcallowip=<ip>/a\rpcallowip=${ip}" $BITCOIN_CONFIG_FILE
    done
  fi 

  if [[ -n "${RPC_USER}" ]] && [[ -n "${RPC_PASSWORD}" ]] ; then

    ## Generate authentication string
    _rpcauth=$(/usr/local/share/rpcauth.py ${RPC_USER} ${RPC_PASSWORD})  

    sed -i "/#rpcauth=.*/c\\${_rpcauth}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${RPC_BIND}" ]]; then
    ## Convert string into an array
    ips=(${RPC_BIND//,/ })

    ## Parse through each item
    for ip in ${ips[@]}; do
      sed -i "/#rpcbind=<addr>[:port]/a\rpcbind=${ip}" $BITCOIN_CONFIG_FILE
    done
  fi 

  if [[ -n "${RPC_COOKIE_FILE}" ]]; then
    sed -i "/#rpccookiefile=.*/c\rpccookiefile=${RPC_COOKIE_FILE}" $BITCOIN_CONFIG_FILE
  fi 

  # if [[ -n "${RPCPASSWORD}" ]]; then
  #   sed -i "/#rpcpassword=.*/c\rpcpassword=${RPCPASSWORD}" $BITCOIN_CONFIG_FILE
  # fi 

  if [[ -n "${RPC_PORT}" ]]; then
    sed -i "/#rpcport=.*/c\rpcport=${RPC_PORT}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${RPC_SERIAL_VERSION}" ]]; then
    if $RPC_SERIAL_VERSION; then _flag=1 ; else _flag=0; fi
    sed -i "/#rpcserialversion=.*/c\rpcserialversion=${_flag}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${RPC_THREADS}" ]]; then
    sed -i "/#rpcthreads=.*/c\rpcthreads=${RPC_THREADS}" $BITCOIN_CONFIG_FILE
  fi 

  # if [[ -n "${RPCUSER}" ]]; then
  #   sed -i "/#rpcuser=.*/c\rpcuser=${RPCUSER}" $BITCOIN_CONFIG_FILE
  # fi 

  if [[ -n "${RPC_WHITE_LIST}" ]]; then
    sed -i "/#rpcwhitelist=.*/c\rpcwhitelist=${RPC_WHITE_LIST}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${RPC_WHITE_LIST_DEFAULT}" ]]; then
    if $RPC_WHITE_LIST_DEFAULT; then _flag=1 ; else _flag=0; fi
    sed -i "/#rpcwhitelistdefault=.*/c\rpcwhitelistdefault=${_flag}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${SERVER}" ]]; then
    if $SERVER; then _flag=1 ; else _flag=0; fi
    sed -i "/#server=.*/c\server=${_flag}" $BITCOIN_CONFIG_FILE
  fi
}

##############################################################################
## Initialise docker image
##############################################################################
init(){
  echo -e "\\n====================================- INITIALISING BITCOIN -===================================="

  ## Copy bitcoin.conf files into bind-volume
  cp /tmp/bitcoin.* ${DATA_DIR}
  ## Don't remove tmp config files incase we want to overwrite new config
  echo "Copied bitcoin.conf into ${DATA_DIR}/..."

}

##############################################################################
## Main function
##############################################################################
main() {

  if [[ ! -e $BITCOIN_CONFIG_FILE.lock ]] || $CONFIG_OVERWRITE; then 
    init
    template_config
    echo "Only run init once. Delete this file to re-init bitcoin.conf on container start up." > $BITCOIN_CONFIG_FILE.lock
  else
    echo "bitcoin.conf already configured. Skipping config templating..."
  fi

  if [[ ! -e /home/${USER}/.bitcoin/bitcoin.conf ]]; then 
    ## Symbolic link config to avoid having set -conf with cli
    mkdir -p /home/${USER}/.bitcoin && chown -R ${USER}:${GROUP} /home/${USER}/.bitcoin && chmod 700 /home/${USER}/.bitcoin
    ln -s ${BITCOIN_CONFIG_FILE} /home/${USER}/.bitcoin/bitcoin.conf
  fi

  ## Log config if set true
  if $LOG_CONFIG; then
    echo_config
  fi
}

# Call main function
main

echo -e "\\n====================================- STARTING BITCOIN CORE -===================================="
# Display Tor version & torrc in log
bitcoind --version
echo ''

exec "$@"