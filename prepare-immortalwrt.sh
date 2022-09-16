#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================

OPENWRT_PATH=`pwd`
echo "Openwrt path: $OPENWRT_PATH"
echo ""

echo "Perpare Script [Start]"

echo ""
echo "Add custom packages feed"
echo "src-git custom https://github.com/icyleaf/openwrt-packages.git" >> feeds.conf.default

echo ""
echo "Add NueXini packages feed"
echo "src-git nuexini https://github.com/NueXini/NueXini_Packages" >> feeds.conf.default

echo ""
echo "Updating feeds"
./scripts/feeds update -a -p custom
./scripts/feeds update -a -p nuexini

# mkdir -p package/icyleaf
# git clone --depth=1 https://github.com/sbwml/luci-app-mosdns.git package/icyleaf/luci-app-mosdns
# git clone --depth=1 https://github.com/sbwml/v2ray-geodata package/icyleaf/v2ray-geodata
# rm -rf package/icyleaf/luci-app-mosdns/mosdns

echo ""
echo "Installing feeds"
./scripts/feeds install -a

# Remove old version packages (custom packages)
rm -rf package/feed/packages/tailscale

##################################
# Custom package
##################################

# echo ""
# echo "Using luci-theme-argon offical source code"
# rm -rf package/lean/luci-theme-argon
# git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

cd $OPENWRT_PATH

##################################
# Settings
##################################
echo ""
echo "Configuring ... openwrt"
# Modify default IP
sed -i 's/192.168.1.1/10.10.10.1/g' package/base-files/files/bin/config_generate

if [ ! -z "$OPENWRT_ROOT_PASSWORD" ]; then
  echo "WARN: root password will change from your secret from 'OPENWRT_ROOT_PASSWORD' secret"
  # Modify password of root if present (encoded password)
  # For example: passwot = $1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.
  sed -i "s|root::0:0:99999:7:::|root:$OPENWRT_ROOT_PASSWORD:0:0:99999:7:::|g" package/base-files/files/etc/shadow
fi

echo "Configuring ... "

echo " -> Tagging RELEASE_TAG"
TEMP=$(date +"Immortalwrt_%Y%m%d_%H%M%S_")$(git rev-parse --short HEAD)
echo "RELEASE_TAG=$TEMP" >> $GITHUB_ENV

echo "Perpare Script [End]"
