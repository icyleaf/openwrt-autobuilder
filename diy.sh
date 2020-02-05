#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# Modify default theme
# sed -i 's/bootstrap/argon/g' openwrt/package/feeds/luci/luci-base/root/etc/config/luci

# custom packages
echo "Download custom packages"
mkdir -p package/icyleaf
cd package/icyleaf

git clone --depth=1 https://github.com/tty228/luci-app-serverchan.git
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash

cd -

# passwall
echo "Add lienol packages feed"
echo "src-git lienol https://github.com/Lienol/openwrt-package" >> feeds.conf.default
./scripts/feeds update -a
./scripts/feeds install -a
