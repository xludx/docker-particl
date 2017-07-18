#!/bin/bash
set -e

HOST="http://localhost:61935"

if [[ ! -z "$1" ]]; then
    HOST="$1";
fi

curl -i --user testnet:testnet \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data "{\"method\":\"getinfo\",\"params\":[],\"id\":1}" "${HOST}"