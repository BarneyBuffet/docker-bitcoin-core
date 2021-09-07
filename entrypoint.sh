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
    if $BLOCK_FILTER_INDEX; then _flag=1 ; else _flag=0; fi
    sed -i "/#blockfilterindex=.*/c\blockfilterindex=${_flag}" $BITCOIN_CONFIG_FILE
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

  if [[ -n "${CONF}" ]]; then
    sed -i "/#conf=.*/c\conf=${CONF}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DAEMON}" ]]; then
    if $DAEMON; then _flag=1 ; else _flag=0; fi
    sed -i "/#daemon=.*/c\daemon=${_flag}" $BITCOIN_CONFIG_FILE
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

  if [[ -n "${MAX_MEM_POOL}" ]]; then
    sed -i "/#maxmempool=.*/c\maxmempool=${MAX_MEM_POOL}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${MAX_ORPHAN_TX}" ]]; then
    sed -i "/#maxorphantx=.*/c\maxorphantx=${MAX_ORPHAN_TX}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${MEM_POOL_EXPIRY}" ]]; then
    sed -i "/#mempoolexpiry=.*/c\mempoolexpiry=${MEM_POOL_EXPIRY}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PAR}" ]]; then
    sed -i "/#par=.*/c\par=${PAR}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PERSISTMEMPOOL}" ]]; then
    if $PERSISTMEMPOOL; then _flag=1 ; else _flag=0; fi
    sed -i "/#persistmempool=.*/c\persistmempool=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PID}" ]]; then
    sed -i "/#pid=.*/c\pid=${PID}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PRUNE}" ]]; then
    if $PRUNE; then _flag=1 ; else _flag=0; fi
    sed -i "/#prune=.*/c\prune=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${REINDEX}" ]]; then
    if $REINDEX; then _flag=1 ; else _flag=0; fi
    sed -i "/#reindex=.*/c\reindex=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${REINDEX_CHAINSTATE}" ]]; then
    if $REINDEX_CHAINSTATE; then _flag=1 ; else _flag=0; fi
    sed -i "/#reindex-chainstate=.*/c\reindex-chainstate=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SETTINGS}" ]]; then
    sed -i "/#settings=.*/c\settings=${SETTINGS}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${STARTUPNOTIFY}" ]]; then
    sed -i "/#startupnotify=.*/c\startupnotify=${STARTUPNOTIFY}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SYSPERMS}" ]]; then
    if $SYSPERMS; then _flag=1 ; else _flag=0; fi
    sed -i "/#sysperms=.*/c\sysperms=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${TXINDEX}" ]]; then
    if $TXINDEX; then _flag=1 ; else _flag=0; fi
    sed -i "/#txindex=.*/c\txindex=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ADDNODE}" ]]; then
    ## Convert string into an array
    nodes=(${ADDNODE//,/ })

    ## Parse through each item
    for node in ${nodes[@]}; do
      sed -i "/#addnode=<address:port>/a\addnode=${node}" $BITCOIN_CONFIG_FILE
    done
  fi
 
  if [[ -n "${ASMAP}" ]]; then
    sed -i "/#asmap=.*/c\asmap=${ASMAP}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BANTIME}" ]]; then
    sed -i "/#bantime=.*/c\bantime=${BANTIME}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BIND}" ]]; then
    sed -i "/#bind=.*/c\bind=${BIND}" $BITCOIN_CONFIG_FILE
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

  if [[ -n "${DNSSEED}" ]]; then
    if $DNSSEED; then _flag=1 ; else _flag=0; fi
    sed -i "/#dnsseed=.*/c\dnsseed=${_flag}" $BITCOIN_CONFIG_FILE
  fi
 
  if [[ -n "${EXTERNALIP}" ]]; then
    sed -i "/#externalip=.*/c\externalip=${EXTERNALIP}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${FORCEDNSSEED}" ]]; then
    if $FORCEDNSSEED; then _flag=1 ; else _flag=0; fi
    sed -i "/#forcednsseed=.*/c\forcednsseed=${_flag}" $BITCOIN_CONFIG_FILE
  fi
 
  if [[ -n "${LISTEN}" ]]; then
    if $LISTEN; then _flag=1 ; else _flag=0; fi
    sed -i "/#listen=.*/c\listen=${_flag}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${LISTENONION}" ]]; then
    if $LISTENONION; then _flag=1 ; else _flag=0; fi
    sed -i "/#listenonion=.*/c\listenonion=${_flag}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${MAXCONNECTIONS}" ]]; then
    sed -i "/#maxconnections=.*/c\maxconnections=${MAXCONNECTIONS}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${MAXRECEIVEBUFFER}" ]]; then
    sed -i "/#maxreceivebuffer=.*/c\maxreceivebuffer=${MAXRECEIVEBUFFER}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${MAXSENDBUFFER}" ]]; then
    sed -i "/#maxsendbuffer=.*/c\maxsendbuffer=${MAXSENDBUFFER}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${MAXTIMEADJUSTMENT}" ]]; then
    sed -i "/#maxtimeadjustment=.*/c\maxtimeadjustment=${MAXTIMEADJUSTMENT}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${MAXUPLOADTARGET}" ]]; then
    sed -i "/#maxuploadtarget=.*/c\maxuploadtarget=${MAXUPLOADTARGET}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${NETWORKACTIVE}" ]]; then
    if $NETWORKACTIVE; then _flag=1 ; else _flag=0; fi
    sed -i "/#networkactive=.*/c\networkactive=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ONION}" ]]; then
    sed -i "/#onion=.*/c\onion=${ONION}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ONLYNET}" ]]; then
    ## Convert string into an array
    nets=(${ONLYNET//,/ })

    ## Parse through each item
    for net in ${nets[@]}; do
      sed -i "/#onlynet=<net>/a\onlynet=${net}" $BITCOIN_CONFIG_FILE
    done
  fi

  if [[ -n "${PEERBLOCKFILTERS}" ]]; then
    if $PEERBLOCKFILTERS; then _flag=1 ; else _flag=0; fi
    sed -i "/#peerblockfilters=.*/c\peerblockfilters=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PEERBLOOMFILTERS}" ]]; then
    if $PEERBLOOMFILTERS; then _flag=1 ; else _flag=0; fi
    sed -i "/#peerbloomfilters=.*/c\peerbloomfilters=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PERMITBAREMULTISIG}" ]]; then
    if $PERMITBAREMULTISIG; then _flag=1 ; else _flag=0; fi
    sed -i "/#permitbaremultisig=.*/c\permitbaremultisig=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PORT}" ]]; then
    sed -i "/#port=.*/c\port=${PORT}" $BITCOIN_CONFIG_FILE
  fi
 
  if [[ -n "${PROXY}" ]]; then
    sed -i "/#proxy=.*/c\proxy=${PROXY}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PROXYRANDOMIZE}" ]]; then
    if $PROXYRANDOMIZE; then _flag=1 ; else _flag=0; fi
    sed -i "/#proxyrandomize=.*/c\proxyrandomize=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SEEDNODE}" ]]; then
    ## Convert string into an array
    nodes=(${SEEDNODE//,/ })

    ## Parse through each item
    for node in ${nodes[@]}; do
      sed -i "/#seednode=<ip>/a\seednode=${node}" $BITCOIN_CONFIG_FILE
    done
  fi

  if [[ -n "${TIMEOUT}" ]]; then
    sed -i "/#timeout=.*/c\timeout=${TIMEOUT}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${TORCONTROL}" ]]; then
    sed -i "/#torcontrol=.*/c\torcontrol=${TORCONTROL}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${TORPASSWORD}" ]]; then
    sed -i "/#torpassword=.*/c\torpassword=${TORPASSWORD}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${UPNP}" ]]; then
    if $UPNP; then _flag=1 ; else _flag=0; fi
    sed -i "/#upnp=.*/c\upnp=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${WHITEBIND}" ]]; then
    sed -i "/#whitebind=.*/c\whitebind=${WHITEBIND}" $BITCOIN_CONFIG_FILE
  fi
 
  if [[ -n "${WHITELIST}" ]]; then
    ## Convert string into an array
    ips=(${WHITELIST//,/ })

    ## Parse through each item
    for ip in ${ips[@]}; do
      sed -i "/#whitelist=<[permissions@]IP address or network>/a\whitelist=${node}" $BITCOIN_CONFIG_FILE
    done
  fi

  if [[ -n "${DEBUG}" ]]; then
    ## TODO: add array
    sed -i "/#debug=.*/c\debug=${DEBUG}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DEBUGEXCLUDE}" ]]; then
    sed -i "/#debugexclude=.*/c\debugexclude=${DEBUGEXCLUDE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${HELP_DEBUG}" ]]; then
    sed -i "/#help-debug/c\help-debug" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${LOGIPS}" ]]; then
    if $LOGIPS; then _flag=1 ; else _flag=0; fi
    sed -i "/#logips=.*/c\logips=${_flag}" $BITCOIN_CONFIG_FILE
  fi
 
  if [[ -n "${LOGTHREADNAMES}" ]]; then
    if $LOGTHREADNAMES; then _flag=1 ; else _flag=0; fi
    sed -i "/#logthreadnames=.*/c\logthreadnames=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${LOGTIMESTAMPS}" ]]; then
    if $LOGTIMESTAMPS; then _flag=1 ; else _flag=0; fi
    sed -i "/#logtimestamps=.*/c\logtimestamps=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${PRINTTOCONSOLE}" ]]; then
    if $PRINTTOCONSOLE; then _flag=1 ; else _flag=0; fi
    sed -i "/#printtoconsole=.*/c\printtoconsole=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SHRINKDEBUGFILE}" ]]; then
    if $SHRINKDEBUGFILE; then _flag=1 ; else _flag=0; fi
    sed -i "/#shrinkdebugfile=.*/c\shrinkdebugfile=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${UACOMMENT}" ]]; then
    sed -i "/#uacomment=.*/c\uacomment=${UACOMMENT}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${CHAIN}" ]]; then
    sed -i "/#chain=.*/c\chain=${CHAIN}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SIGNET}" ]]; then
    if $SIGNET; then _flag=1 ; else _flag=0; fi
    sed -i "/#signet=.*/c\signet=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SIGNETCHALLENGE}" ]]; then
    sed -i "/#signetchallenge/c\signetchallenge" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${SIGNETSEEDNODE}" ]]; then
    ## Convert string into an array
    nodes=(${SIGNETSEEDNODE//,/ })

    ## Parse through each item
    for node in ${nodes[@]}; do
      sed -i "/#signetseednode=<host[:port]>/a\signetseednode=${node}" $BITCOIN_CONFIG_FILE
    done
  fi

  if [[ -n "${TESTNET}" ]]; then
    if $TESTNET; then _flag=1 ; else _flag=0; fi
    sed -i "/#testnet=.*/c\testnet=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BYTESPERSIGOP}" ]]; then
    sed -i "/#bytespersigop=.*/c\bytespersigop=${BYTESPERSIGOP}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DATACARRIER}" ]]; then
    if $DATACARRIER; then _flag=1 ; else _flag=0; fi
    sed -i "/#datacarrier=.*/c\datacarrier=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${DATACARRIERSIZE}" ]]; then
    sed -i "/#datacarriersize=.*/c\datacarriersize=${DATACARRIERSIZE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${MINRELAYTXFEE}" ]]; then
    sed -i "/#minrelaytxfee=.*/c\minrelaytxfee=${MINRELAYTXFEE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${WHITELISTFORCERELAY}" ]]; then
    if $WHITELISTFORCERELAY; then _flag=1 ; else _flag=0; fi
    sed -i "/#whitelistforcerelay=.*/c\whitelistforcerelay=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${WHITELISTRELAY}" ]]; then
    if $WHITELISTRELAY; then _flag=1 ; else _flag=0; fi
    sed -i "/#whitelistrelay=.*/c\whitelistrelay=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BLOCKMAXWEIGHT}" ]]; then
    sed -i "/#blockmaxweight=.*/c\blockmaxweight=${BLOCKMAXWEIGHT}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${BLOCKMINTXFEE}" ]]; then
    sed -i "/#blockmintxfee=.*/c\blockmintxfee=${BLOCKMINTXFEE}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${REST}" ]]; then
    if $REST; then _flag=1 ; else _flag=0; fi
    sed -i "/#rest=.*/c\rest=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${RPCALLOWIP}" ]]; then
    ## Convert string into an array
    ips=(${RPCALLOWIP//,/ })

    ## Parse through each item
    for ip in ${ips[@]}; do
      sed -i "/#rpcallowip=127.0.0.1/a\rpcallowip=${ip}" $BITCOIN_CONFIG_FILE
    done
  fi 

  if [[ -n "${RPCUSER}" ]] && [[ -n "${RPCPASSWORD}" ]] ; then

    ## Generate authentication string
    _rpcauth=$(/usr/local/share/rpcauth.py ${RPCUSER} ${RPCPASSWORD})  

    sed -i "/#rpcauth=.*/c\/${_rpcauth}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${RPCBIND}" ]]; then
    ## Convert string into an array
    ips=(${RPCBIND//,/ })

    ## Parse through each item
    for ip in ${ips[@]}; do
      sed -i "/#rpcbind=127.0.0.1:8332/a\rpcbind=${ip}" $BITCOIN_CONFIG_FILE
    done
  fi 

  if [[ -n "${RPCCOOKIEFILE}" ]]; then
    sed -i "/#rpccookiefile=.*/c\rpccookiefile=${RPCCOOKIEFILE}" $BITCOIN_CONFIG_FILE
  fi 

  # if [[ -n "${RPCPASSWORD}" ]]; then
  #   sed -i "/#rpcpassword=.*/c\rpcpassword=${RPCPASSWORD}" $BITCOIN_CONFIG_FILE
  # fi 

  if [[ -n "${RPCPORT}" ]]; then
    sed -i "/#rpcport=.*/c\rpcport=${RPCPORT}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${RPCSERIALVERSION}" ]]; then
    if $RPCSERIALVERSION; then _flag=1 ; else _flag=0; fi
    sed -i "/#rpcserialversion=.*/c\rpcserialversion=${_flag}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${RPCTHREADS}" ]]; then
    sed -i "/#rpcthreads=.*/c\rpcthreads=${RPCTHREADS}" $BITCOIN_CONFIG_FILE
  fi 

  # if [[ -n "${RPCUSER}" ]]; then
  #   sed -i "/#rpcuser=.*/c\rpcuser=${RPCUSER}" $BITCOIN_CONFIG_FILE
  # fi 

  if [[ -n "${RPCWHITELIST}" ]]; then
    sed -i "/#rpcwhitelist=.*/c\rpcwhitelist=${RPCWHITELIST}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${RPCWHITELISTDEFAULT}" ]]; then
    if $RPCWHITELISTDEFAULT; then _flag=1 ; else _flag=0; fi
    sed -i "/#rpcwhitelistdefault=.*/c\rpcwhitelistdefault=${_flag}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${SERVER}" ]]; then
    if $SERVER; then _flag=1 ; else _flag=0; fi
    sed -i "/#server=.*/c\server=${_flag}" $BITCOIN_CONFIG_FILE
  fi

  if [[ -n "${ZMQPUBHASHTX}" ]]; then
    sed -i "/#zmqpubhashtx=.*/c\zmqpubhashtx=${ZMQPUBHASHTX}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${ZMQPUBHASHBLOCK}" ]]; then
    sed -i "/#zmqpubhashblock=.*/c\zmqpubhashblock=${ZMQPUBHASHBLOCK}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${ZMQPUBRAWBLOCK}" ]]; then
    sed -i "/#zmqpubrawblock=.*/c\zmqpubrawblock=${ZMQPUBRAWBLOCK}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${ZMQPUBRAWTX}" ]]; then
    sed -i "/#zmqpubrawtx=.*/c\zmqpubrawtx=${ZMQPUBRAWTX}" $BITCOIN_CONFIG_FILE
  fi 

  if [[ -n "${ZMQPUBSEQUENCE}" ]]; then
    sed -i "/#zmqpubsequence=.*/c\zmqpubsequence=${ZMQPUBSEQUENCE}" $BITCOIN_CONFIG_FILE
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