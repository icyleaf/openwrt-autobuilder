# OpenWrt-AutoBuilder

![Build x86 OpenWrt](https://github.com/icyleaf/openwrt-autobuilder/workflows/Build%20x86%20OpenWrt/badge.svg?branch=master)
![Build amd64 OpenWrt](https://github.com/icyleaf/openwrt-autobuilder/workflows/Build%20amd64%20OpenWrt/badge.svg?branch=master)

Openwrt x86(i386/32bit)/amd86(x86 64bit) CPU 自動鏡像生成 Based on [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)

[Read the details in p3terx's blog (in Chinese) | 中文教程](https://p3terx.com/archives/build-openwrt-with-github-actions.html)

## Configuration

- Gateway: 10.10.10.1
- Theme: bootstrap (default)
- Change Root password if present (Copy encoded password from /etc/shadow)

## API

https://documenter.getpostman.com/view/14290/SzKPUgEo

## Customize your own

- Click the [Use this template](https://github.com/P3TERX/Actions-OpenWrt/generate) button to create a new repository.
- Generate `.config` files using [Lean's OpenWrt](https://github.com/coolsnowwolf/lede) source code. ( You can change it through environment variables in the workflow file. )
- Push `.config` file to the GitHub repository, and the build starts automatically.Progress can be viewed on the Actions page.
- When the build is complete, click the `Artifacts` button in the upper right corner of the Actions page to download the binaries.

## Build on local

### Linux

Follow [lede's Readme](https://github.com/coolsnowwolf/lede/blob/master/README.md)

### Docker

- Custom `docker-compose.yml`
- Run `docker-compose up -d`
- Execute `openwrt-builder` contaienr inside and run:
  - /workspace/bootstrap
  - /openwrt/src/make download -j8
  - /openwrt/scr/make -j$(nproc) || make -j1 || make -j1 V=s

**Tips**: Openwrt requires Case-sensitive disk, You need create a read-write virtualdisk on macOS

```bash
# 最少 50G 空间
# -size 空间大小
# -fs "Case-sensitive APFS" 大小写敏感 APFS 分区格式，老系统用 "Case-sensitive HFS+"
# -type SPARSE 稀疏磁盘映像
# -volname 卷名字，挂载会显示在 /Volumes 下面，默认是 "untitled"
# 最后的参数是镜像保存的路径文件名
hdiutil create -size 50g \
  -fs "Case-sensitive APFS" \
	-type SPARSE \
  -volname OpenWrt \
  OpenWrtBuilder.sparseimage

# 挂载刚创建好的镜像，就看到 /Volumes/OpenWrt 路径
hdiutil attach OpenWrtBuilder.sparseimage
```
