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
##################################
# Custom feed
##################################
echo "add kenzok8/openwrt-packages feeds"
echo "src-git kenzok8 https://github.com/kenzok8/small-package" >> feeds.conf.default

echo ""
echo "Updating feeds"
./scripts/feeds update -a

echo ""
echo "Installing feeds"
./scripts/feeds install -a

##################################
# Custom package
##################################

# echo ""
# echo "Using luci-theme-argon offical source code"
# rm -rf package/lean/luci-theme-argon
# git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

echo ""
echo "Downloading Custom packages"
git clone --depth=1 https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
git clone --depth=1 -b master https://github.com/vernesong/OpenClash.git package/OpenClash
mv package/OpenClash/luci-app-openclash package/luci-app-openclash
rm -rf package/OpenClash

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

echo ""
echo "Configuring ... "

echo " -> Tagging RELEASE_TAG"
TEMP=$(date +"OpenWrt_%Y%m%d_%H%M%S_")$(git rev-parse --short HEAD)
echo "RELEASE_TAG=$TEMP" >> $GITHUB_ENV

echo "-> writing luci-app-easyupdate"
#required>>add "DISTRIB_GITHUB" to "zzz-default-settings"
sed -i "/DISTRIB_DESCRIPTION=/a\sed -i '/DISTRIB_GITHUB/d' /etc/openwrt_release" package/lean/default-settings/files/zzz-default-settings
sed -i "/DISTRIB_GITHUB/a\echo \"DISTRIB_GITHUB=\'https://github.com/${GITHUB_REPO}\'\" >> /etc/openwrt_release" package/lean/default-settings/files/zzz-default-settings
#required>>add "DISTRIB_VERSIONS" to "zzz-default-settings"
sed -i "/DISTRIB_DESCRIPTION=/a\sed -i '/DISTRIB_VERSIONS/d' /etc/openwrt_release" package/lean/default-settings/files/zzz-default-settings
sed -i "/DISTRIB_VERSIONS/a\echo \"DISTRIB_VERSIONS=\'${TEMP:8}\'\" >> /etc/openwrt_release" package/lean/default-settings/files/zzz-default-settings
#nonessential>>add "github.actor" to "DISTRIB_DESCRIPTION" in "zzz-default-settings"
sed -i "s/OpenWrt /${GITHUB_USER} compiled (${TEMP:8}) \/ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# Modify default theme
# sed -i 's/bootstrap/argon/g' package/feeds/luci/luci-base/root/etc/config/luci

echo "Perpare Script [End]"
