FROM alpine:latest

ENV BITLBEE_COMMIT=bef5d78031b01c2d443c7c949727c7baca298c9c \
    DISCORD_COMMIT=aa0bbf2df851b1fd1b27164713121d20c610b7c5 \
    MATTERMOST_COMMIT=e21f18c4d868bf6db4e3d436eddcaca5da5effe0 \
    PUSHBULLET_COMMIT=8a7837c13a3ff445325aa20cf1fb556dbf4a76f0 \
    ROCKETCHAT_COMMIT=826990b48f41d77e1280f5fa51082ed2f5115ddf \
    SKYPE_COMMIT=2f5a3e2413c9c69722d26fb4432190cf1f6458d9 \
    SLACK_COMMIT=be97802c7fd0b611722d2f551756e2a2672f6084 \
    TELEGRAM_COMMIT=44a1349bf4c57e8b648dae113ec7cf3bdbde0789 \
    VK_COMMIT=51a91c83561741996a07af46cba512b9c86b8e98 \
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
    hg clone -U https://bitbucket.org/EionRobb/purple-rocketchat; \
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

# vkontakte
RUN apk add --no-cache --virtual build-dependencies \
    build-base \
    cmake \
    libtool \
    libxml2-dev \
    mercurial \
    pidgin-dev; \
    cd /root; \
    hg clone -U https://bitbucket.org/olegoandreev/purple-vk-plugin; \
    cd purple-vk-plugin; \
    hg update ${VK_COMMIT}; \
    cd build; \
    cmake ..; \
    make; \
    make install; \
    strip /usr/lib/purple-2/libpurple-vk-plugin.so; \
    rm -rf /root; \
    mkdir /root; \
    apk del --purge build-dependencies

# Install runtime dependencies
RUN apk add --no-cache ${RUNTIME_DEPS}

EXPOSE 6667
VOLUME /bitlbee-data

USER bitlbee
ENTRYPOINT ["/usr/local/sbin/bitlbee", "-F", "-n", "-d", "/bitlbee-data", "-c", "/bitlbee.conf"]
