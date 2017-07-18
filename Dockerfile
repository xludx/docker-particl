FROM debian:stretch-slim
#FROM ubuntu:16.10
MAINTAINER Juha Kovanen <juha@particl.io>

ENV PARTICL_VERSION 0.14.1.10
ENV PARTICL_DATA=/root/.particl
ENV PATH=/opt/particl-${PARTICL_VERSION}/bin:$PATH

RUN apt-get update -y \
    && apt-get install -y ca-certificates wget curl gnupg2 autogen git \
    && apt-get install -y build-essential libtool autotools-dev autoconf \
    && apt-get install -y pkg-config libssl-dev libboost-all-dev \
    && apt-get install -y libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools \
    && apt-get install -y libprotobuf-dev protobuf-compiler libqrencode-dev autoconf \
    && apt-get install -y openssl libssl-dev libevent-dev libminiupnpc-dev bsdmainutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /root \
    && git clone https://github.com/particl/particl-core.git
RUN cd /root/particl-core \
    && mkdir db4 \
    && cd db4 \
    && wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz' \
    && tar -xzvf db-4.8.30.NC.tar.gz \
    && cd db-4.8.30.NC/build_unix \
    && ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=/root/particl-core/db4/ \
    && make install
RUN cd /root/particl-core \
    && ./autogen.sh \
    && ./configure LDFLAGS="-L/root/particl-core/db4/lib/" CPPFLAGS="-I/root/particl-core/db4/include/" \
    && make -s -j4

RUN mkdir /root/.particl
VOLUME ["/root/.particl"]

RUN mkdir -p /opt/particl-${PARTICL_VERSION}/bin \
    && cp -rf /root/particl-core/src/particl-cli /root/particl-core/src/particl-tx /root/particl-core/src/particld /opt/particl-${PARTICL_VERSION}/bin/

COPY docker-entrypoint.sh /opt/particl-${PARTICL_VERSION}/bin/entrypoint.sh

ENV PATH="/opt/particl-${PARTICL_VERSION}/bin:${PATH}"
RUN chmod +x /opt/particl-${PARTICL_VERSION}/bin/*

EXPOSE 51738 51935

HEALTHCHECK --interval=5m --timeout=3s --retries=3 \
    CMD particl-cli getinfo || exit 1

ENTRYPOINT ["entrypoint.sh"]
CMD ["particld"]

