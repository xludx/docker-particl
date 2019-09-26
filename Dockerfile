FROM debian:stretch-slim
#FROM ubuntu:16.10
MAINTAINER Juha Kovanen <juha@particl.io>

ARG CONTAINER_TIMEZONE=Europe/Helsinki
ARG PARTICL_VERSION=master
ARG BUILD=false

ENV PARTICL_DATA=/root/.particl
ENV PATH=/opt/particl-${PARTICL_VERSION}/bin:$PATH

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y apt-transport-https ca-certificates wget curl gnupg2 autogen git net-tools iputils-ping \
    build-essential libtool autotools-dev automake autoconf pkg-config libssl-dev libboost-all-dev ntp ntpdate \
    libzmq3-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler \
    libqrencode-dev autoconf openssl libevent-dev libminiupnpc-dev bsdmainutils libsodium-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# RUN echo "deb http://deb.torproject.org/torproject.org stretch main" >> /etc/apt/sources.list
# RUN echo "deb-src http://deb.torproject.org/torproject.org stretch main" >> /etc/apt/sources.list
# RUN gpg --keyserver keys.gnupg.net --recv-keys 886DDD89
# RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

# RUN apt-get update -y \
#    && apt-get install -y tor deb.torproject.org-keyring proxychains \
#    && apt-get clean \
#    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# RUN usermod -a -G debian-tor root

RUN echo ${CONTAINER_TIMEZONE} >/etc/timezone && \
    ln -sf /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    echo "Container timezone set to: $CONTAINER_TIMEZONE"

RUN ntpdate -q ntp.ubuntu.com

RUN if [ "${PARTICL_VERSION}" = "master" ]; then \
        cd /root \
        && git clone https://github.com/particl/particl-core.git \
        && cd particl-core \
        && cd /root/particl-core \
        && mkdir db4 \
        && cd /root/particl-core/db4 \
        && wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz' \
        && tar -xzvf db-4.8.30.NC.tar.gz \
        && cd /root/particl-core/db4/db-4.8.30.NC/build_unix \
        && ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/root/particl-core/db4/ \
        && make install \
        && cd /root/particl-core \
        && ./autogen.sh \
        && ./configure LDFLAGS="-L/root/particl-core/db4/lib/" CPPFLAGS="-I/root/particl-core/db4/include/" \
        && make; \
    elif [ "${BUILD}" = "true" ]; then \
        cd /root \
        && git clone https://github.com/particl/particl-core.git \
        && cd particl-core \
        && git fetch --all --tags --prune \
        && git checkout tags/v${PARTICL_VERSION} -b v${PARTICL_VERSION} \
        && cd /root/particl-core \
        && mkdir db4 \
        && cd /root/particl-core/db4 \
        && wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz' \
        && tar -xzvf db-4.8.30.NC.tar.gz \
        && cd /root/particl-core/db4/db-4.8.30.NC/build_unix \
        && ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/root/particl-core/db4/ \
        && make install \
        && cd /root/particl-core \
        && ./autogen.sh \
        && ./configure LDFLAGS="-L/root/particl-core/db4/lib/" CPPFLAGS="-I/root/particl-core/db4/include/" \
        && make; \
    else \
        cd /root \
        && mkdir -p particl-core/src \
        && cd particl-core \
        # && wget https://github.com/particl/particl-core/releases/download/v${PARTICL_VERSION}/particl-${PARTICL_VERSION%alpha}-x86_64-linux-gnu.tar.gz \
        # && tar -xzvf particl-${PARTICL_VERSION%alpha}-x86_64-linux-gnu.tar.gz \
        # && cp -rf particl-${PARTICL_VERSION%alpha}/bin/* src/; \
        # https://github.com/particl/particl-core/releases/download/v0.18.0.5rc1/particl-0.18.0.5-x86_64-linux-gnu.tar.gz
        && wget https://github.com/particl/particl-core/releases/download/v${PARTICL_VERSION}/particl-${PARTICL_VERSION%rc1}-x86_64-linux-gnu.tar.gz \
        && tar -xzvf particl-${PARTICL_VERSION%rc1}-x86_64-linux-gnu.tar.gz \
        && cp -rf particl-${PARTICL_VERSION%rc1}/bin/* src/; \
    fi


RUN mkdir /root/.particl
VOLUME ["/root/.particl"]
# VOLUME ["/var/lib/tor"]

RUN mkdir -p /opt/particl/bin \
    && cp -rf /root/particl-core/src/particl-cli /root/particl-core/src/particl-tx /root/particl-core/src/particld /opt/particl/bin/ \
    && rm -rf /root/particl-core

COPY docker-entrypoint.sh /opt/particl/bin/entrypoint.sh
COPY bin/rpcauth.py /opt/particl/bin/rpcauth.py

ENV PATH="/opt/particl/bin:${PATH}"
RUN chmod +x /opt/particl/bin/*
# RUN /etc/init.d/tor stop

EXPOSE 51738 51935

HEALTHCHECK --interval=5m --timeout=3s --retries=3 \
    CMD particl-cli getnetworkinfo || exit 1

ENTRYPOINT ["entrypoint.sh"]
CMD ["particld"]

