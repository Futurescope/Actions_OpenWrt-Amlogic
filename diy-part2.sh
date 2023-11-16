#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 设置密码为空
sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings

# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci/Makefile

# Modify some code adaptation
#sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' feeds/luci/applications/luci-app-cpufreq/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set DISTRIB_REVISION
sed -i "s/OpenWrt /Deng Build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.2.1）
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# Modify system hostname（FROM OpenWrt CHANGE TO OpenWrt-N1）
# sed -i 's/OpenWrt/OpenWrt-N1/g' package/base-files/files/bin/config_generate

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings

sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template


# 拉取软件包

# git clone https://github.com/kenzok8/small-package package/small-package
# svn co https://github.com/kiddin9/openwrt-packages/trunk/UnblockNeteaseMusic-Go package/openwrt-packages
# 更换netdata为汉化版
rm -rf ./feeds/luci/applications/luci-app-netdata/
git clone https://github.com/Jason6111/luci-app-netdata ./feeds/luci/applications/luci-app-netdata/
# 添加其他软件
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
svn co https://github.com/nantayo/passwall/trunk package/passwall

# 删除重复包

# rm -rf feeds/luci/applications/luci-app-netdata
# rm -rf feeds/luci/themes/luci-theme-argon
# rm -rf package/small-package/luci-app-openvpn-server
# rm -rf package/small-package/openvpn-easy-rsa-whisky
# rm -rf package/small-package/luci-app-wrtbwmon
# rm -rf package/small-package/wrtbwmon
# rm -rf package/small-package/luci-app-koolproxyR
# rm -rf package/small-package/luci-app-godproxy
# rm -rf package/small-package/luci-app-argon*
# rm -rf package/small-package/luci-theme-argon*
# rm -rf package/small-package/luci-app-amlogic
# rm -rf package/small-package/luci-app-unblockneteasemusic
# rm -rf package/small-package/opkg
# 
# # 编译问题
# rm -rf package/small-package/upx
# rm -rf package/small-package/upx-static
# rm -rf package/small-package/firewall*
rm -rf package/small-package/miniupnpd-iptables
rm -rf feeds/small8/miniupnpd-iptables

# 其他调整
# NAME=$"package/luci-app-unblockneteasemusic/root/usr/share/unblockneteasemusic" && mkdir -p $NAME/core
# curl 'https://api.github.com/repos/UnblockNeteaseMusic/server/commits?sha=enhanced&path=precompiled' -o commits.json
# echo "$(grep sha commits.json | sed -n "1,1p" | cut -c 13-52)">"$NAME/core_local_ver"
# curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/app.js -o $NAME/core/app.js
# curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/bridge.js -o $NAME/core/bridge.js
# curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/ca.crt -o $NAME/core/ca.crt
# curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.crt -o $NAME/core/server.crt
# curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.key -o $NAME/core/server.key

sed -i 's#https://github.com/breakings/OpenWrt#https://github.com/quanjindeng/Actions_OpenWrt-Amlogic#g' package/luci-app-amlogic/luci-app-amlogic/root/etc/config/amlogic
sed -i 's#ARMv8#openwrt_armvirt_v8#g' package/luci-app-amlogic/luci-app-amlogic/root/etc/config/amlogic
sed -i 's#opt/kernel#kernel#g' package/luci-app-amlogic/luci-app-amlogic/root/etc/config/amlogic

sed -i 's#mount -t cifs#mount.cifs#g' feeds/luci/applications/luci-app-cifs-mount/root/etc/init.d/cifs

#sed -i 's#<%+cbi/tabmenu%>##g' package/small-packages/luci-app-nginx-manager/luasrc/view/nginx-manager/index.htm

