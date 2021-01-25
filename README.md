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

## Build your own

- Click the [Use this template](https://github.com/P3TERX/Actions-OpenWrt/generate) button to create a new repository.
- Generate `.config` files using [Lean's OpenWrt](https://github.com/coolsnowwolf/lede) source code. ( You can change it through environment variables in the workflow file. )
- Push `.config` file to the GitHub repository, and the build starts automatically.Progress can be viewed on the Actions page.
- When the build is complete, click the `Artifacts` button in the upper right corner of the Actions page to download the binaries.

## Acknowledgments

- [Microsoft](https://www.microsoft.com)
- [Microsoft Azure](https://azure.microsoft.com)
- [GitHub](https://github.com)
- [GitHub Actions](https://github.com/features/actions)
- [tmate](https://github.com/tmate-io/tmate)
- [mxschmitt/action-tmate](https://github.com/mxschmitt/action-tmate)
- [csexton/debugger-action](https://github.com/csexton/debugger-action)
- [Cisco](https://www.cisco.com/)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [Lean's OpenWrt](https://github.com/coolsnowwolf/lede)
- [Lienol's OpenWrt package](https://github.com/Lienol/openwrt-package)
