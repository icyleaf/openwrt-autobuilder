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
cd package/feeds

svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash

git clone https://github.com/pymumu/luci-app-smartdns
svn co https://github.com/pymumu/smartdns/trunk/package/openwrt smartdns

cd -
