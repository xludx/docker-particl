#!/bin/bash
set -e

#HOST="http://localhost:61935"
HOST="http://localhost:61738"
RPCCOMMAND="getinfo"
RPCPARAMS="[]"

if [[ ! -z "$1" ]]; then
    HOST="$1";
fi

if [[ ! -z "$2" ]]; then
    RPCCOMMAND="$2";
fi

if [[ ! -z "$3" ]]; then
    RPCPARAMS="$3";
fi

curl -i --user testnet:testnet \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data "{\"method\":\"${RPCCOMMAND}\",\"params\":${RPCPARAMS},\"id\":1}" "${HOST}" 
#| python -m json.tool
