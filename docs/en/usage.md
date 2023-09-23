# Dashboard

Sphia provides a dashboard for viewing the current status.

There are currently five cards, running cores, rule groups, DNS, traffic and speed charts.

## Running cores

This card shows **all** cores that are currently running. Click the core name to view the github repository address of
the core and all servers running under the core.

## Rule groups

You can switch rule groups here.

## DNS

You can modify the remote DNS and direct DNS here.

## Traffic

Only displayed when statistics are enabled.

## Speed chart

Only displayed when statistics are enabled.

# Server page

Sphia manages servers through groups, and comes with a group named `Default` by default, which cannot be modified or
deleted. You can switch groups through the tabs, which will change the server list in the tray icon.

You can click the `...` button in the upper right corner of the server page to manage the server group and servers in
the group.

## Group

Groups have two properties: name and subscription. The group name cannot be empty. If you want to get the server from
the subscription, the subscription cannot be empty. Please do not put non-subscription nodes in the subscription group,
otherwise these nodes **will be deleted** when updating the subscription.

## Server

You can manually enter server information, import server information from the clipboard, or import server information
from the subscription. Sphia **will not** strictly check the server information.

# Rule page

Sphia manages rules through groups, and comes with groups named `Default`, `Direct` and `Global` by default, of which
the `Default` group cannot be modified or deleted. You can switch groups through the tabs, which will change the
selected state of the rule group in the tray icon.

You can click the `...` button in the upper right corner of the rule page to manage the rule group and rules in the
group.

## Group

Groups have one property: name. The group name cannot be empty.

## Rule

Sphia supports xray-core style rules, you can view the syntax of rules
in [xray-core documentation](https://xtls.github.io/config/routing.html). When using sing-box as the routing core, Sphia
will automatically convert the rules.

# Setting page

Sphia provides rich setting options, you can modify the behavior of Sphia here. After modifying and saving any settings,
Sphia will pop up a prompt to modify the settings.

Sphia **will not** automatically restart the core after modifying the settings.

# Update page

You can download or update the core and rule data here.

# Log page

When the core log is turned on, you can see the log of the routing core here.

# About page

You can view the version, build number and last commit hash of Sphia here.

When a new version is detected, you can click the button to download and install the new version.
