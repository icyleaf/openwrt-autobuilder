FROM ubuntu:18.04
LABEL maintainer="icyleaf <icyleaf.cn@gmail.com>"

ENV MIRROR_SOURCE_URL="mirrors.ustc.edu.cn" \
    TZ="Asia/Shanghai" \
    DEBIAN_FRONTEND=noninteractive \
    CADDY_VERSION=2.3.0 \
    WORKSPACE_PATH="/workspace" \
    OPENWRT_PATH="/openwrt"

RUN set -ex && \
    sed -i "s/archive.ubuntu.com/${MIRROR_SOURCE_URL}/g" /etc/apt/sources.list && \
    apt-get clean && \
    apt-get update -y && \
    apt-get install -y sudo ca-certificates build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget curl swig rsync && \
    apt-get -qq autoremove --purge && \
    apt-get -qq clean && \
    groupadd -r openwrt && \
    useradd -g openwrt -rs /bin/bash openwrt && \
    adduser openwrt sudo && \
    mkdir /openwrt && \
    chown -R openwrt:openwrt /openwrt && \
    rm -rf /var/lib/apt/lists/*

RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://github.com/caddyserver/caddy/releases/download/v${CADDY_VERSION}/caddy_${CADDY_VERSION}_linux_amd64.tar.gz" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy && \
    chmod 0755 /usr/bin/caddy

WORKDIR ${WORKSPACE_PATH}
COPY ./ ./
RUN chmod +x *.sh && \
    chmod +x bootstrap && \
    chmod +x complie && \
    chown -R openwrt:openwrt /workspace

USER openwrt

EXPOSE 80 2019

CMD ["/usr/bin/caddy", "run", "-config", "/workspace/Caddyfile"]
