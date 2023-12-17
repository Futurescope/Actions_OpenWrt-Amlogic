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

# sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template

# 修复部分插件自启动脚本丢失可执行权限问题
sed -i '/exit 0/i\chmod +x /etc/init.d/*' package/lean/default-settings/files/zzz-default-settings

# 拉取软件包

# git clone https://github.com/kenzok8/small-package package/small-package
# 更换netdata为汉化版
rm -rf ./feeds/luci/applications/luci-app-netdata/
git clone https://github.com/Jason6111/luci-app-netdata ./feeds/luci/applications/luci-app-netdata
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
git clone https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset
git clone https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns
svn co https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
svn co https://github.com/doushang/luci-app-shortcutmenu/trunk/luci-app-shortcutmenu package/luci-app-shortcutmenu
svn co https://github.com/sundaqiang/openwrt-packages/trunk/luci-app-wolplus package/luci-app-wolplus
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic

#　git clone https://github.com/linkease/istore-ui.git package/istore-ui
#　git clone https://github.com/linkease/istore.git package/istore
#　sed -i 's/luci-lib-ipkg/luci-base/g' package/istore/luci/luci-app-store/Makefile

# 删除重复包
# passwall
rm -rf feeds/passwall_packages/pdnsd-alt #与lean重复
rm -rf feeds/packages/net/v2ray-geodata/*
mv feeds/passwall_packages/v2ray-geodata/* feeds/packages/net/v2ray-geodata/
rm -rf feeds/passwall_packages/v2ray-geodata
# rm -rf feeds/luci/themes/luci-theme-argon
# 
# # 编译问题
# rm -rf package/small-package/upx

# 添加主题
svn co https://github.com/rosywrt/luci-theme-rosy/trunk/luci-theme-rosy package/luci-theme-rosy

# 其他调整
# NAME=$"package/luci-app-unblockneteasemusic/root/usr/share/unblockneteasemusic" && mkdir -p $NAME/core
# curl 'https://api.github.com/repos/UnblockNeteaseMusic/server/commits?sha=enhanced&path=precompiled' -o commits.json
# echo "$(grep sha commits.json | sed -n "1,1p" | cut -c 13-52)">"$NAME/core_local_ver"
# curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/app.js -o $NAME/core/app.js
# curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/bridge.js -o $NAME/core/bridge.js
# curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/ca.crt -o $NAME/core/ca.crt
# curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.crt -o $NAME/core/server.crt
# curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.key -o $NAME/core/server.key

# Amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
# Modify the default configuration of Amlogic Box
# 1.Set the download repository of the OpenWrt files to your github.com（OpenWrt 文件的下载仓库）
sed -i "s|https.*/OpenWrt|https://github.com/Futurescope/Actions_OpenWrt-Amlogic|g" package/luci-app-amlogic/root/etc/config/amlogic
# 2.Set the keywords of Tags in your github.com Releases（Releases 里 Tags 的关键字）
sed -i "s|ARMv8|openwrt_N1|g" package/luci-app-amlogic/root/etc/config/amlogic
# 3.Set the suffix of the OPENWRT files in your github.com Releases（Releases 里 OpenWrt 文件的后缀）
#sed -i "s|.img.gz|_Full.img.gz|g" package/luci-app-amlogic/root/etc/config/amlogic
# 4.Set the download path of the kernel in your github.com repository（OpenWrt 内核的下载路径）
sed -i "s|opt/kernel|https://github.com/breakings/OpenWrt|g" package/luci-app-amlogic/root/etc/config/amlogic

sed -i 's#mount -t cifs#mount.cifs#g' feeds/luci/applications/luci-app-cifs-mount/root/etc/init.d/cifs
