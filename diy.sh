#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================

# Modify default IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# custom packages
echo "Download custom packages"
mkdir -p package/icyleaf
cd package/icyleaf

git clone --depth=1 https://github.com/tty228/luci-app-serverchan.git
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash

cd -
