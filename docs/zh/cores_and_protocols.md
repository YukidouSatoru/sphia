# 支持的核心

## 路由核心

Sphia 使用以下核心作为路由核心：

- [sing-box](https://github.com/SagerNet/sing-box)
- [xray-core](https://github.com/xtls/xray-core)

## 服务器核心

Sphia 使用以下核心作为服务器核心：

- [sing-box](https://github.com/SagerNet/sing-box)
- [xray-core](https://github.com/xtls/xray-core)
- [shadowsocks-rust](https://github.com/shadowsocks/shadowsocks-rust)
- [hysteria](https://github.com/apernet/hysteria)

# 支持的协议

- VMess （未完全支持）
- VLESS （未完全支持）
- Shadowsocks
- Shadowsocks-2022
- Trojan
- Hysteria

VMess 和 VLESS 支持 tcp、ws、grpc、httpupgrade （由 sing-box 提供） 传输方式，支持 reality。

在使用 Shadowsocks 协议时，请注意当前加密方式是否被 Shadowsocks 提供者支持。

## 调用逻辑

你可以在设置页面中的“Provider”选项卡中修改路由核心和各协议的提供者（即服务器核心）。

当路由核心和服务器核心不一致时，Sphia 会将路由核心作为服务器核心的上游。**不建议**使用这种组合，此时代理的行为可能会出现不可预料的问题。

在 TUN 模式下，Sphia 只会使用 sing-box 同时作为路由核心和服务器核心。
