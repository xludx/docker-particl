build:
	time docker build --build-arg CONTAINER_TIMEZONE=Europe/Helsinki -t ludx/particl -t docker.io/ludx/particl:0.16.0.1rc1 -t docker.io/ludx/particl:latest .

run:
	docker run --name particld -e CONF_RPCUSERNAME=testnet -e CONF_RPCPASSWORD=testnet \
	-e CONF_BIND=127.0.0.1 -e CONF_PRINTTOCONSOLE=1 -e CONF_SERVER=1 -e CONF_LISTEN=0 -p 61738:51738 -p 61935:51935 \
	-v /Users/juha/Work/particl/docker-particl/data/particl:/root/.particl -v /Users/juha/Work/particl/docker-particl/data/particl-tor:/var/lib/tor docker.io/ludx/particl:latest

#      - CONF_ONLYNET=onion              # Only connect to nodes in network: ipv4, ipv6 or onion
#      - CONF_PROXY=127.0.0.1:9050       # Connect through SOCKS5 proxy
#      - CONF_ONION=127.0.0.1:9050       # Use separate SOCKS5 proxy to reach peers via Tor hidden services (default: -proxy)
#      - CONF_RPCALLOWIP=0.0.0.0/0       # Allow JSON-RPC connections from specified source. Valid for <ip> are a single IP (e.g. 1.2.3.4), a network/netmask (e.g. 1.2.3.4/255.255.255.0) or a network/CIDR (e.g. 1.2.3.4/24).
#      - CONF_REST=0                    # Accept public REST requests (default: 0)
#      - CONF_LISTEN=1                   # Accept connections from outside (default: 1 if no -proxy or -connect)
#      - CONF_LISTENONION=1              # Automatically create Tor hidden service (default: 1)
#      - CONF_TORCONTROL=127.0.0.1:9051  # Tor control port to use if onion listening enabled (default: 127.0.0.1:9051)
#      - CONF_TORPASSWORD=particltor     # Tor control port password, generated unless set
#      - CONF_DISCOVER=1                # Discover own IP address (default: 1 when listening and no -externalip)
#      - CONF_BIND=127.0.0.1             # Bind to given address and always listen on it. Use [host]:port notation for IPv6
#      - CONF_DEBUG=tor                    # Output debugging information: 0/1, addrman, alert, bench, cmpctblock, coindb, db, http, libevent, lock, mempool, mempoolrej, net, proxy, prune, rand, reindex, rpc, selectcoins, tor, zmq, qt.
#      - CREATEDEFAULTMASTERKEY=true

start:
	docker start particld

stop:
	docker stop particld

rm:
	docker rm -f particld

logs:
	docker logs -f --tail 1000 particld

push:
	docker push docker.io/ludx/particl:latest
	docker push docker.io/ludx/particl:0.16.0.1rc1
