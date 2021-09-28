#!/bin/bash
set -eo pipefail

## Get the number of node connections
CONNECTIONS=$(gosu nonroot bitcoin-cli getconnectioncount);

## If we have no connections throw an error
if [ "$CONNECTIONS" -eq "0" ]; then
    ## Log error
    echo "HEALTHCHECK: FAIL - Bitcoind has ${CONNECTIONS} active node connections.";
    ## Exit with error
    exit 1;
else
    ## Log succesful health check
    echo "HEALTHCHECK: SUCCESS - Bitcoind has ${CONNECTIONS} active node connections.";
    ## Exit with success
    exit 0;
fi