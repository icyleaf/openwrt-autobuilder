#!/bin/bash

OPENWRT_PATH=${OPENWRT_PATH:-`pwd`}
echo "Openwrt path: $OPENWRT_PATH"
echo ""

echo "Perpare Script [Start]"
cd $OPENWRT_PATH

echo ""
echo "Add icyleaf packages feed"
echo "src-git icyleaf https://github.com/icyleaf/openwrt-packages.git" >> feeds.conf.default

echo ""
echo "Updating feeds"
./scripts/feeds update -a

echo ""
echo "Installing feeds"
./scripts/feeds install -a

##################################
# Custom package
##################################

echo ""
echo "Downloading Custom packages"
mkdir -p package/custom

# Remove old version packages (use icyleaf packages instead)
rm -rf package/feed/packages/tailscale

# Remove mosdns and v2ray-geodata packages (use custom packages instead)
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f

# pre-download geoip & geosite
mkdir -p files/usr/share/v2ray-test
curl -o files/usr/share/v2ray-test/geoip.dat https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat
curl -o files/usr/share/v2ray-test/geosite.dat https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat

# install mosdns and luci-app-mosdns
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone --depth=1  https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# install luci-app-log
git clone --depth=1 -b master https://github.com/gSpotx2f/luci-app-log.git package/luci-app-log

##################################
# Custom package
##################################

echo ""
echo "Speed up script"

echo "Replace node version to 23.05"
rm -rf feeds/packages/lang/node
git clone https://github.com/sbwml/feeds_packages_lang_node-prebuilt -b packages-23.05 feeds/packages/lang/node

echo "Replace golang version to 1.23"
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

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
TEMP=$(date +"Immortalwrt_%Y%m%d_%H%M%S_")$(git rev-parse --abbrev-ref HEAD)
echo "RELEASE_TAG=$TEMP" >> $GITHUB_ENV

##################################
# Dumping
##################################
echo "Dumping language versions ..."
find $OPENWRT_PATH/feeds/packages/lang/ -type d ! -name '*-*' -exec grep -H 'GO_VERSION_MAJOR_MINOR:\|PKG_VERSION:' {}/Makefile \; 2>/dev/null

echo "Perpare Script [End]"
