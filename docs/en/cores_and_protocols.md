# List of supported cores

## Routing Cores

Sphia uses the following cores as routing cores:

- [sing-box](https://github.com/SagerNet/sing-box)
- [xray-core](https://github.com/xtls/xray-core)

## Server Cores

Sphia uses the following cores as server cores:

- [sing-box](https://github.com/SagerNet/sing-box)
- [xray-core](https://github.com/xtls/xray-core)
- [shadowsocks-rust](https://github.com/shadowsocks/shadowsocks-rust)
- [hysteria](https://github.com/apernet/hysteria)

# List of supported protocols

- VMess (not fully supported)
- VLESS (not fully supported)
- Shadowsocks
- Shadowsocks-2022
- Trojan
- Hysteria

VMess and VLESS support tcp, ws, grpc and httpupgrade (provided by sing-box) transmission modes, and support reality.

When using the Shadowsocks protocol, please pay attention to whether the current encryption method is supported by the
Shadowsocks provider.

## Invocation logic

You can modify the routing core and the provider of each protocol (i.e. the server core) in the "Provider" tab in the
Settings page.

When the routing core and the server core are inconsistent, Sphia will use the routing core as the upstream of the
server core. **It is not recommended** to use this combination, and the proxy behavior may have unpredictable problems.

In TUN mode, Sphia will only use sing-box as both the routing core and the server core.
