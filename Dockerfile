FROM alpine:latest

ENV BITLBEE_COMMIT=75222ab2b4542ee8b4726feee0d2c65636e3c7e3 \
    DISCORD_COMMIT=48e96efb860a0633baa98ff7960e40001bbd3b0f \
    MATTERMOST_COMMIT=158ce2052af9aaf3d1f6f045f0cfba276e0e91cf \
    PUSHBULLET_COMMIT=8a7837c13a3ff445325aa20cf1fb556dbf4a76f0 \
    ROCKETCHAT_COMMIT=5da3e14b5b57f5fe7dd58f176ff1433fe5397c0d \
    SKYPE_COMMIT=f836eebcda6eba6e321d5baa2efd1934ab43ed1d \
    SLACK_COMMIT=b61b4dd07987edde84ba7dcdef12746a32f37ebe \
    TELEGRAM_COMMIT=323cab7698e3830db797422a2ad2f6bb2678d272 \
    RUNTIME_DEPS=" \
    cyrus-sasl \
    cyrus-sasl-crammd5 \
    cyrus-sasl-digestmd5 \
    cyrus-sasl-scram \
    cyrus-sasl-plain \
    glib \
    gnutls \
    json-glib \
    libevent \
    libgcrypt \
    libotr \
    libpurple \
    libpurple-bonjour \
    libpurple-oscar \
    libpurple-xmpp \
    libsasl \
    openldap \
    protobuf-c"

# bitlbee
RUN apk add --update --no-cache --virtual build-dependencies \
    build-base \
    git \
    gnutls-dev \
    libevent-dev \
    libotr-dev \
    pidgin-dev \
    openldap-dev; \
    apk add --no-cache --virtual runtime-dependencies ${RUNTIME_DEPS}; \
    cd /root; \
    git clone -n https://github.com/bitlbee/bitlbee; \
    cd bitlbee; \
    git checkout ${BITLBEE_COMMIT}; \
    cp bitlbee.conf /bitlbee.conf; \
    mkdir /bitlbee-data; \
    ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --debug=0 --events=libevent --ldap=1 --otr=plugin --purple=1 --config=/bitlbee-data; \
    make; \
    make install; \
    make install-dev; \
    make install-etc; \
    adduser -u 1000 -S bitlbee; \
    addgroup -g 1000 -S bitlbee; \
    chown -R bitlbee:bitlbee /bitlbee-data; \
    touch /var/run/bitlbee.pid; \
    chown bitlbee:bitlbee /var/run/bitlbee.pid; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# discord
RUN apk add --no-cache --virtual build-dependencies \
    autoconf \
    automake \
    build-base \
    git \
    glib-dev \
    libtool; \
    cd /root; \
    git clone -n https://github.com/sm00th/bitlbee-discord; \
    cd bitlbee-discord; \
    git checkout ${DISCORD_COMMIT}; \
    ./autogen.sh; \
    ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl; \
    make; \
    make install; \
    strip /usr/local/lib/bitlbee/discord.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# mattermost
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    discount-dev \
    git \
    json-glib-dev \
    pidgin-dev; \
    cd /root; \
    git clone -n https://github.com/EionRobb/purple-mattermost; \
    cd purple-mattermost; \
    git checkout ${MATTERMOST_COMMIT}; \
    make; \
    make install; \
    strip /usr/lib/purple-2/libmattermost.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# pushbullet
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    git \
    json-glib-dev \
    pidgin-dev; \
    cd /root; \
    git clone -n https://github.com/EionRobb/pidgin-pushbullet; \
    cd pidgin-pushbullet; \
    git checkout ${PUSHBULLET_COMMIT}; \
    make; \
    make install; \
    strip /usr/lib/purple-2/libpushbullet.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# rocket.chat
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    discount-dev \
    json-glib-dev \
    mercurial \
    pidgin-dev; \
    cd /root; \
    hg clone -U https://github.com/EionRobb/purple-rocketchat; \
    cd purple-rocketchat; \
    hg update ${ROCKETCHAT_COMMIT}; \
    make; \
    make install; \
    strip /usr/lib/purple-2/librocketchat.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# skype
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    git \
    json-glib-dev \
    pidgin-dev; \
    cd /root; \
    git clone -n https://github.com/EionRobb/skype4pidgin; \
    cd skype4pidgin; \
    git checkout ${SKYPE_COMMIT}; \
    cd skypeweb; \
    make; \
    make install; \
    strip /usr/lib/purple-2/libskypeweb.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# slack
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    git \
    pidgin-dev; \
    cd /root; \
    git clone -n https://github.com/dylex/slack-libpurple; \
    cd slack-libpurple; \
    git checkout ${SLACK_COMMIT}; \
    make; \
    make install; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# telegram
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    git \
    libgcrypt-dev \
    pidgin-dev; \
    cd /root; \
    git clone -n https://github.com/majn/telegram-purple; \
    cd telegram-purple; \
    git checkout ${TELEGRAM_COMMIT}; \
    git submodule update --init --recursive; \
    ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --disable-libwebp; \
    make; \
    make install; \
    strip /usr/lib/purple-2/telegram-purple.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# Install runtime dependencies
RUN apk add --no-cache ${RUNTIME_DEPS}

EXPOSE 6667
VOLUME /bitlbee-data

USER bitlbee
ENTRYPOINT ["/usr/local/sbin/bitlbee", "-F", "-n", "-d", "/bitlbee-data", "-c", "/bitlbee.conf"]
