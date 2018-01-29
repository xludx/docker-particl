#!/bin/bash

set -e


PARTICL_CONF="${PARTICL_DATA}/particl.conf"

if [[ ! -z "${CONF_CLEAN_INIT}" ]]; then
    rm -rf ${PARTICL_CONF}
#    rm -rf /var/lib/tor/torrc.current
fi

# if [[ -f "/var/lib/tor/torrc.current" ]]
# then
#    cp /var/lib/tor/torrc.current /etc/tor/torrc
# fi

# recreate everything if theres no particl.conf
if [[ ! -f "${PARTICL_CONF}" ]]
then

#    cp /etc/tor/torrc /var/lib/tor/torrc.org
#    cp /usr/share/tor/tor-service-defaults-torrc /var/lib/tor/tor-service-defaults-torrc.org

#    rm -rf /etc/tor/torrc
#    rm -rf /usr/share/tor/tor-service-defaults-torrc

#    chown -R debian-tor:debian-tor /var/lib/tor
#    chmod -R 700 /var/lib/tor

#    CONF_TORPASSWORD=${CONF_TORPASSWORD:-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)}

    # echo "HiddenServiceDir /var/lib/tor/particl-service/" >> /etc/tor/torrc
    # echo "HiddenServicePort 51738 127.0.0.1:51738" >> /etc/tor/torrc
    # echo "HiddenServicePort 51935 127.0.0.1:51935" >> /etc/tor/torrc

#    echo "DataDirectory /var/lib/tor" >> /etc/tor/torrc
#    echo "PidFile /var/lib/tor/tor.pid" >> /etc/tor/torrc
#    echo "RunAsDaemon 1" >> /etc/tor/torrc
#    echo "User debian-tor" >> /etc/tor/torrc

    # echo "ControlSocket /var/run/tor/control GroupWritable RelaxDirModeCheck" >> /etc/tor/torrc
    # echo "ControlSocketsGroupWritable 1" >> /etc/tor/torrc

#    echo "SocksPort unix:/var/run/tor/socks WorldWritable" >> /etc/tor/torrc
#    echo "SocksPort 9050" >> /etc/tor/torrc

#    echo "ControlPort 9051" >> /etc/tor/torrc
#    echo "HashedControlPassword $(tor --hash-password ${CONF_TORPASSWORD} | sed -n '2p')" >> /etc/tor/torrc

#    echo "Log notice syslog" >> /etc/tor/torrc

    # echo "CookieAuthentication 1" >> /etc/tor/torrc
    # echo "CookieAuthFile /var/lib/tor/control.authcookie" >> /etc/tor/torrc
    # echo "CookieAuthFileGroupReadable 1" >> /etc/tor/torrc

#    cp /etc/tor/torrc /var/lib/tor/torrc.current

    # more /etc/tor/torrc

#    /etc/init.d/tor start


    echo "${PARTICL_CONF} does not exist, creating..."
    touch ${PARTICL_CONF}

    # HOSTNAME='/var/lib/tor/particl-service/hostname'
    # until [ -e $HOSTNAME ]; do
    #    echo "waiting for tor $HOSTNAME, sleeping for 5s..."
    #    ls -al /var/lib/tor/particl-service
    #    sleep 5;
    # done
    # TORHOSTNAME=$(cat $HOSTNAME)
    # echo "...onion address is ${TORHOSTNAME}"

    RPCUSERNAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo "rpcuser=${CONF_RPCUSERNAME:-$RPCUSERNAME}" >> ${PARTICL_CONF}
    echo "rpcpassword=${CONF_RPCPASSWORD:-$RPCPASSWORD}" >> ${PARTICL_CONF}
    echo "printtoconsole=${CONF_PRINTTOCONSOLE:-1}" >> ${PARTICL_CONF}

    if [[ ! -z "${CONF_TESTNET}" ]]; then
        echo "testnet=${CONF_TESTNET}" >> ${PARTICL_CONF}
    fi

    if [[ ! -z "${CONF_SERVER}" ]]; then
        echo "server=${CONF_SERVER}" >> ${PARTICL_CONF}
        if [[ "${CONF_SERVER}" == 1 ]]; then
            echo "rpcallowip=10.211.0.0/16" >> ${PARTICL_CONF}
            echo "rpcallowip=172.17.0.0/16" >> ${PARTICL_CONF}
            echo "rpcallowip=192.168.0.0/16" >> ${PARTICL_CONF}
            echo "rpcallowip=${CONF_RPCALLOWIP:-127.0.0.1}" >> ${PARTICL_CONF}
        fi
    fi

    if [[ ! -z "${CONF_REST}" ]]; then
        echo "rest=${CONF_REST}" >> ${PARTICL_CONF}
    fi

    if [[ ! -z "${CONF_ONLYNET}" ]]; then
        echo "onlynet=${CONF_ONLYNET}" >> ${PARTICL_CONF}
    fi

    if [[ ! -z "${CONF_PROXY}" ]]; then
        echo "proxy=${CONF_PROXY}" >> ${PARTICL_CONF}
        echo "externalip=${TORHOSTNAME}" >> ${PARTICL_CONF}
    fi

    if [[ ! -z "${CONF_ONION}" ]]; then
        echo "onion=${CONF_ONION}" >> ${PARTICL_CONF}
        echo "externalip=${TORHOSTNAME}" >> ${PARTICL_CONF}
    fi

    if [[ ! -z "${CONF_LISTENONION}" ]]; then
        echo "listenonion=${CONF_LISTENONION}" >> ${PARTICL_CONF}
    fi

    if [[ ! -z "${CONF_TORCONTROL}" ]]; then
        echo "torcontrol=${CONF_TORCONTROL}" >> ${PARTICL_CONF}
        if [[ ! -z "${CONF_TORPASSWORD}" ]]; then
            echo "torpassword=${CONF_TORPASSWORD}" >> ${PARTICL_CONF}
        fi
    fi

    if [[ ! -z "${CONF_LISTEN}" ]]; then
        echo "listen=${CONF_LISTEN}" >> ${PARTICL_CONF}
    fi

    if [[ ! -z "${CONF_BIND}" ]]; then
        echo "bind=${CONF_BIND}" >> ${PARTICL_CONF}
    fi

    if [[ ! -z "${CONF_DISCOVER}" ]]; then
        echo "discover=${CONF_DISCOVER}" >> ${PARTICL_CONF}
    fi

    if [[ ! -z "${CONF_MAXCONNECTIONS}" ]]; then
        echo "maxconnections=${CONF_MAXCONNECTIONS}" >> ${PARTICL_CONF}
    fi

    if [[ ! -z "${CONF_DEBUG}" ]]; then
        echo "debug=${CONF_DEBUG}" >> ${PARTICL_CONF}
    fi
else
    echo "${PARTICL_CONF} allready generated..."
fi

echo
echo "particl.conf:"
echo
more $PARTICL_CONF

if [[ "$1" = "particld" ]]; then
    if [[ "${CREATEDEFAULTMASTERKEY}" = true ]]; then
        set -- "$@" -datadir="${PARTICL_DATA}" -conf="${PARTICL_CONF}" -createdefaultmasterkey
        exec "$@"
    else
        set -- "$@" -datadir="${PARTICL_DATA}" -conf="${PARTICL_CONF}"
        exec "$@"
    fi

fi
