#!/bin/bash

set -e

export PARTICL_CONF="${PARTICL_DATA}/particl.conf"

if [[ ! -f "${PARTICL_CONF}" ]]
then
    echo "${PARTICL_CONF} does not exist, creating..."
    touch ${PARTICL_CONF}
    RPCUSERNAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo "rpcallowip=${CONF_RPCALLOWIP:-127.0.0.1}" >> ${PARTICL_CONF}
    echo "rpcuser=${CONF_RPCUSERNAME:-$RPCUSERNAME}" >> ${PARTICL_CONF}
    echo "rpcpassword=${CONF_RPCPASSWORD:-$RPCPASSWORD}" >> ${PARTICL_CONF}
    echo "printtoconsole=${CONF_PRINTTOCONSOLE:-1}" >> ${PARTICL_CONF}
else
    echo "${PARTICL_CONF} allready exists..."
fi

if [[ "$1" = "particld" ]]; then
    set -- "$@" -datadir="${PARTICL_DATA}" -conf=${PARTICL_CONF}
    exec "$@"
fi
