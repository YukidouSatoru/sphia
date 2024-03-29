# 仪表盘

Sphia 提供了一个仪表盘，用于查看当前的状态。

目前有五个卡片，正在运行的核心、规则分组、DNS、流量和速度图表。

## 正在运行的核心

这个卡片显示了当前正在运行的**所有**核心。单击核心名称，可以查看该核心的 github 仓库地址和运行在该核心下的所有服务器。

## 规则分组

你可以在这里切换规则分组。

## DNS

你可以在这里修改远程 DNS 和直连 DNS。

## 流量

仅在统计启用时显示数据。

## 速度图表

仅在统计启用时显示数据。当多出站支持启用时，此图表显示的是总速度，获取的 IP 地址来自主代理服务器。

# 服务器页面

Sphia 通过分组管理服务器，默认带有一个名为 `Default` 的分组，此分组不可修改和删除。你可以通过选项卡切换分组，此行为会改变托盘图标中的服务器列表。

你可以在服务器页面的右上角点击 `...` 按钮对服务器分组和分组中的服务器进行管理。

## 分组

分组有两个属性：名称和订阅。分组名称不能为空。如果你希望从订阅获取服务器，则订阅不能为空。请不要将非订阅节点放入订阅分组中，否则在更新订阅时，这些节点
**将被删除**。

分组有一个选项：获取订阅。你可以开启此选项，Sphia 会在添加分组后自动获取订阅。

## 服务器

你可以手动输入服务器信息，从剪切板导入服务器信息，或者从订阅中导入服务器信息。Sphia **不会**对服务器信息进行严格的检查。

# 规则页面

Sphia 通过分组管理规则，默认带有名为 `Default`、`Direct` 和 `Global` 的分组，其中 `Default`
分组不可修改和删除。你可以通过选项卡切换分组，此行为会改变托盘图标中的规则组的选种状态。

你可以在规则页面的右上角点击 `...` 按钮对规则分组和分组中的规则进行管理。

## 分组

分组有一个属性：名称。分组名称不能为空。

## 规则

Sphia 支持 xray-core 风格的规则，你可以在 [xray-core 文档](https://xtls.github.io/config/routing.html) 中查看规则的语法。在使用
sing-box 作为路由核心时，Sphia 会自动转换规则。

Sphia 提供多出站支持，对应规则 `outboundTag` 字段，默认的标签有 `proxy`、`direct` 和 `block`。`null` 标签会被忽略，所在的规则也不会被转换。除了默认的标签，你可以将服务器添加为 `outboundTag`，此时 Sphia 只会使用 sing-box 或 xray-core 作为路由核心和服务器核心，并且 sing-box 不支持流量统计。

# 设置页面

Sphia 提供了丰富的设置选项，你可以在这里修改 Sphia 的行为。在修改并保存任何设置后，Sphia 会弹出该设置的修改提示。

Sphia **不会**在修改设置后自动重启核心。

# 更新页面

你可以在这里下载或更新核心和规则数据。

# 日志页面

当核心日志打开时，你可以在这里看到路由核心的日志。

# 关于页面

你可以在这里看到 Sphia 的版本号、构建号和最后一次提交的哈希值。

# 更新按钮

当检测到新版本时，导航栏会显示一个更新按钮，你可以点击此按钮来更新 Sphia。
