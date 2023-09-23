<h1 align="center">
  <img src="https://github.com/YukidouSatoru/sphia/raw/main/assets/logo_about.png" alt="Sphia" width="200">
  <br>Sphia<br>
</h1>

<h4 align="center">Sphia - a Proxy Handling Intuitive Application</h4>

<p align="center">
  <a href="https://github.com/YukidouSatoru/sphia/actions/workflows/release.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/YukidouSatoru/sphia/release.yml?style=flat-square" alt="Github Actions">
  </a>
  <a href="https://github.com/YukidouSatoru/sphia/releases">
    <img src="https://img.shields.io/github/v/release/YukidouSatoru/sphia?include_prereleases&style=flat-square" alt="Github Release">
  </a>
  <a href="https://github.com/leanflutter/flutter_distributor">
    <img src="https://img.shields.io/badge/distribute%20with-flutter__distributor-green?style=flat-square" alt="Distribute with flutter_distributor">
  </a>
</p>

## Platform Support

| Linux AMD64 | Windows AMD64 | macOS Intel | macOS Apple Silicon |
|:-----------:|:-------------:|:-----------:|:-------------------:|
|      ✅      |       ✅       |      ✅      |          ✅          |

## Documentation

Visit it [here](docs/home.md).

## Features

- Multiple groups for servers and routing rules
- Import subscription from URL
- TUN support (Using sing-box, required administrator permission)
- Support manual core update
- Statistics for traffic
- Protocol
    - VMess (Not fully supported yet)
    - VLESS (Not fully supported yet)
    - Shadowsocks
    - Shadowsocks-2022
    - Trojan
    - Hysteria
- Cores
    - Routing Cores
        - [sing-box](https://github.com/SagerNet/sing-box)
        - [xray-core](https://github.com/xtls/xray-core)
    - Server Cores
        - [sing-box](https://github.com/SagerNet/sing-box)
        - [xray-core](https://github.com/xtls/xray-core)
        - [shadowsocks-rust](https://github.com/shadowsocks/shadowsocks-rust)
        - [hysteria](https://github.com/apernet/hysteria)

## License

[GPL-3.0](./LICENSE)
