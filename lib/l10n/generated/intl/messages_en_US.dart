// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_US locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en_US';

  static String m0(coreName) => "Core not found: ${coreName}";

  static String m1(coreName) => "Are you sure to delete the core ${coreName}?";

  static String m2(remark) => "Are you sure to delete the server ${remark}?";

  static String m3(coreName) => "Deleted ${coreName} successfully";

  static String m4(binPath) =>
      "Selected cores or rule data have been copied to ${binPath}, and cores will be scanned automatically. The version number of the rule data cannot be obtained";

  static String m5(count, total) =>
      "${count}/${total} subscriptions have been updated";

  static String m6(coreName, version) =>
      "Updated ${coreName} to ${version} successfully";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("About"),
        "add": MessageLookupByLibrary.simpleMessage("Add"),
        "addGroup": MessageLookupByLibrary.simpleMessage("Add Group"),
        "addServer": MessageLookupByLibrary.simpleMessage("Add Server"),
        "additionalSocksPort":
            MessageLookupByLibrary.simpleMessage("Additional Socks Port"),
        "additionalSocksPortMsg": MessageLookupByLibrary.simpleMessage(
            "Additional Socks port used for communication between the routing provider and other core components. If not necessary, please avoid running multiple cores simultaneously"),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "addressEnterMsg":
            MessageLookupByLibrary.simpleMessage("Please enter an address"),
        "allGroups": MessageLookupByLibrary.simpleMessage("All Groups"),
        "allowInsecure": MessageLookupByLibrary.simpleMessage("Allow Insecure"),
        "alpn": MessageLookupByLibrary.simpleMessage("ALPN"),
        "alreadyLatestVersion":
            MessageLookupByLibrary.simpleMessage("Already latest version"),
        "alterId": MessageLookupByLibrary.simpleMessage("Alter ID"),
        "alterIdEnterMsg":
            MessageLookupByLibrary.simpleMessage("Please enter an Alter ID"),
        "alterIdInvalidMsg": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid Alter ID"),
        "authPayload": MessageLookupByLibrary.simpleMessage("Auth Payload"),
        "authType": MessageLookupByLibrary.simpleMessage("Auth Type"),
        "authentication":
            MessageLookupByLibrary.simpleMessage("Authentication"),
        "authenticationMsg": MessageLookupByLibrary.simpleMessage(
            "Enable authentication for the local server"),
        "autoConfigureSystemProxy":
            MessageLookupByLibrary.simpleMessage("Auto Enable System Proxy"),
        "autoConfigureSystemProxyMsg": MessageLookupByLibrary.simpleMessage(
            "Configure system proxy automatically when core starts or stops, default off"),
        "autoGetIp": MessageLookupByLibrary.simpleMessage("Auto Get IP"),
        "autoGetIpMsg": MessageLookupByLibrary.simpleMessage(
            "Automatically get current IP, default off"),
        "autoRoute": MessageLookupByLibrary.simpleMessage("Auto Route"),
        "autoRouteMsg": MessageLookupByLibrary.simpleMessage(
            "Tun automatically configure routes, default on"),
        "autoRunServer":
            MessageLookupByLibrary.simpleMessage("Auto Run Server"),
        "autoRunServerMsg": MessageLookupByLibrary.simpleMessage(
            "Automatically run the last selected server when Sphia starts"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cannotEditOrDeleteGroup":
            MessageLookupByLibrary.simpleMessage("Cannot edit or delete group"),
        "checkUpdate": MessageLookupByLibrary.simpleMessage("Check Update"),
        "checkUpdateFailed":
            MessageLookupByLibrary.simpleMessage("Failed to check update"),
        "checkingUpdate":
            MessageLookupByLibrary.simpleMessage("Checking update"),
        "clearTraffic": MessageLookupByLibrary.simpleMessage("Clear Traffic"),
        "configuration": MessageLookupByLibrary.simpleMessage("Configuration"),
        "configureDns": MessageLookupByLibrary.simpleMessage("Configure DNS"),
        "configureDnsMsg": MessageLookupByLibrary.simpleMessage(
            "Configure DNS for the routing provider, default on. Currently only supports configuring remote and direct DNS. Please note the format of the address"),
        "connectToGithubFailed":
            MessageLookupByLibrary.simpleMessage("Failed to connect to Github"),
        "coreApiPort": MessageLookupByLibrary.simpleMessage("Core API Port"),
        "coreApiPortMsg": MessageLookupByLibrary.simpleMessage(
            "The port used for retrieving traffic statistics from the core API"),
        "coreNotFound": m0,
        "coreStart": MessageLookupByLibrary.simpleMessage("Start Core"),
        "coreStartFailed":
            MessageLookupByLibrary.simpleMessage("Failed to start core"),
        "coreStop": MessageLookupByLibrary.simpleMessage("Stop Core"),
        "currentGroup": MessageLookupByLibrary.simpleMessage("Current Group"),
        "currentIp": MessageLookupByLibrary.simpleMessage("Current IP"),
        "currentVersion":
            MessageLookupByLibrary.simpleMessage("Current Version"),
        "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
        "darkModeMsg": MessageLookupByLibrary.simpleMessage(
            "Enable dark mode, default on"),
        "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteCore": MessageLookupByLibrary.simpleMessage("Delete Core"),
        "deleteCoreConfirm": m1,
        "deleteCoreFailed":
            MessageLookupByLibrary.simpleMessage("Failed to delete core"),
        "deleteGroup": MessageLookupByLibrary.simpleMessage("Delete Group"),
        "deleteServer": MessageLookupByLibrary.simpleMessage("Delete Server"),
        "deleteServerConfirm": m2,
        "deletedCoreSuccessfully": m3,
        "directDns": MessageLookupByLibrary.simpleMessage("Direct DNS"),
        "directDnsMsg": MessageLookupByLibrary.simpleMessage(
            "Direct DNS, default is https+local://doh.pub/dns-query. Sing-Box will attempt resolution before startup.\nIf you are not sure about the DNS format of the routing provider, please do not modify"),
        "disableMtuDiscovery":
            MessageLookupByLibrary.simpleMessage("Disable MTU Discovery"),
        "dns": MessageLookupByLibrary.simpleMessage("DNS"),
        "dnsIsNotConfigured":
            MessageLookupByLibrary.simpleMessage("DNS is not configured"),
        "domainMatcher": MessageLookupByLibrary.simpleMessage("Domain Matcher"),
        "domainMatcherMsg": MessageLookupByLibrary.simpleMessage(
            "Domain matcher, default is hybrid. Only applicable to xray-core"),
        "domainStrategy":
            MessageLookupByLibrary.simpleMessage("Domain Strategy"),
        "domainStrategyMsg": MessageLookupByLibrary.simpleMessage(
            "Domain strategy, default is IPIfNonMatch. Only applicable to xray-core"),
        "downMbps": MessageLookupByLibrary.simpleMessage("Down Mbps"),
        "downMbpsEnterMsg":
            MessageLookupByLibrary.simpleMessage("Please enter a Down Mbps"),
        "downMbpsInvalidMsg": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid Down Mbps"),
        "download": MessageLookupByLibrary.simpleMessage("Download"),
        "downloadSpeed": MessageLookupByLibrary.simpleMessage("Download Speed"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "editGroup": MessageLookupByLibrary.simpleMessage("Edit Group"),
        "enableCoreLog":
            MessageLookupByLibrary.simpleMessage("Enable Core Log"),
        "enableCoreLogMsg": MessageLookupByLibrary.simpleMessage(
            "Enable core logs, default on"),
        "enableIpv4": MessageLookupByLibrary.simpleMessage("Enable IPv4"),
        "enableIpv4Msg": MessageLookupByLibrary.simpleMessage(
            "Enable IPv4 for Tun, enabled and cannot be changed"),
        "enableIpv6": MessageLookupByLibrary.simpleMessage("Enable IPv6"),
        "enableIpv6Msg":
            MessageLookupByLibrary.simpleMessage("Enable IPv6 for Tun"),
        "enableSniffing":
            MessageLookupByLibrary.simpleMessage("Enable Sniffing"),
        "enableSniffingMsg": MessageLookupByLibrary.simpleMessage(
            "Enable traffic sniffing, default on"),
        "enableSpeedChart":
            MessageLookupByLibrary.simpleMessage("Enable Speed Chart"),
        "enableSpeedChartMsg": MessageLookupByLibrary.simpleMessage(
            "Enable speed chart, default off"),
        "enableStatistics":
            MessageLookupByLibrary.simpleMessage("Enable Statistics"),
        "enableStatisticsMsg": MessageLookupByLibrary.simpleMessage(
            "Enable statistics, default off. When turned on, it will track the traffic and display speed on the dashboard"),
        "enableTun": MessageLookupByLibrary.simpleMessage("Enable Tun"),
        "enableTunMsg": MessageLookupByLibrary.simpleMessage(
            "Enable Tun, requires administrator privileges"),
        "enableUdp": MessageLookupByLibrary.simpleMessage("Enable UDP"),
        "enableUdpMsg": MessageLookupByLibrary.simpleMessage(
            "Enable UDP, only applicable to local Socks server"),
        "encryption": MessageLookupByLibrary.simpleMessage("Encryption"),
        "endpointIndependentNat":
            MessageLookupByLibrary.simpleMessage("Endpoint Independent NAT"),
        "endpointIndependentNatMsg": MessageLookupByLibrary.simpleMessage(
            "Endpoint Independent NAT, default off"),
        "enterValidNumberMsg":
            MessageLookupByLibrary.simpleMessage("Please enter a valid number"),
        "exit": MessageLookupByLibrary.simpleMessage("Exit"),
        "exportToClipboard":
            MessageLookupByLibrary.simpleMessage("Export to Clipboard"),
        "exportToFile": MessageLookupByLibrary.simpleMessage("Export to File"),
        "fetchSubscription":
            MessageLookupByLibrary.simpleMessage("Fetch Subscription"),
        "fingerPrint": MessageLookupByLibrary.simpleMessage("FingerPrint"),
        "flow": MessageLookupByLibrary.simpleMessage("Flow"),
        "getIpFailed": MessageLookupByLibrary.simpleMessage("Failed to get IP"),
        "gettingIp": MessageLookupByLibrary.simpleMessage("Getting IP"),
        "groupHasNoSubscription":
            MessageLookupByLibrary.simpleMessage("Group has no subscription"),
        "groupName": MessageLookupByLibrary.simpleMessage("Group Name"),
        "groupNameEnterMsg":
            MessageLookupByLibrary.simpleMessage("Please enter a group name"),
        "grpcMode": MessageLookupByLibrary.simpleMessage("gRPC Mode"),
        "grpcServiceName":
            MessageLookupByLibrary.simpleMessage("gRPC Service Name"),
        "hide": MessageLookupByLibrary.simpleMessage("Hide"),
        "host": MessageLookupByLibrary.simpleMessage("Host"),
        "httpPort": MessageLookupByLibrary.simpleMessage("HTTP Port"),
        "httpPortMsg": MessageLookupByLibrary.simpleMessage(
            "HTTP port, only applicable to xray-core"),
        "hysteriaProtocol":
            MessageLookupByLibrary.simpleMessage("Hysteria Protocol"),
        "hysteriaProvider":
            MessageLookupByLibrary.simpleMessage("Hysteria Provider"),
        "hysteriaProviderMsg": MessageLookupByLibrary.simpleMessage(
            "Hysteria provider, default is sing-box"),
        "import": MessageLookupByLibrary.simpleMessage("Import"),
        "importCoreFailed":
            MessageLookupByLibrary.simpleMessage("Failed to import core"),
        "importCoreSuccessfully":
            MessageLookupByLibrary.simpleMessage("Imported core successfully"),
        "importFromClipboard":
            MessageLookupByLibrary.simpleMessage("Import from Clipboard"),
        "importMultiCoresMsg": m4,
        "ipv4Address": MessageLookupByLibrary.simpleMessage("IPv4 Address"),
        "ipv4AddressMsg":
            MessageLookupByLibrary.simpleMessage("Tun IPv4 address"),
        "ipv6Address": MessageLookupByLibrary.simpleMessage("IPv6 Address"),
        "ipv6AddressMsg":
            MessageLookupByLibrary.simpleMessage("Tun IPv6 address"),
        "latestVersion": MessageLookupByLibrary.simpleMessage("Latest Version"),
        "launchUrlFailed":
            MessageLookupByLibrary.simpleMessage("Failed to launch URL"),
        "listen": MessageLookupByLibrary.simpleMessage("Listen"),
        "listenMsg": MessageLookupByLibrary.simpleMessage(
            "Local server listening address, default is 127.0.0.1"),
        "log": MessageLookupByLibrary.simpleMessage("Log"),
        "logLevel": MessageLookupByLibrary.simpleMessage("Log Level"),
        "logLevelMsg": MessageLookupByLibrary.simpleMessage(
            "Log level, default is warning"),
        "maxLogCount": MessageLookupByLibrary.simpleMessage("Max Log Count"),
        "maxLogCountMsg": MessageLookupByLibrary.simpleMessage(
            "Maximum number of logs displayed, default is 64"),
        "mixedPort": MessageLookupByLibrary.simpleMessage("Mixed Port"),
        "mixedPortMsg": MessageLookupByLibrary.simpleMessage(
            "Mixed port, only applicable to sing-box"),
        "mtu": MessageLookupByLibrary.simpleMessage("MTU"),
        "mtuMsg":
            MessageLookupByLibrary.simpleMessage("Tun MTU, default is 9000"),
        "multiOutboundSupport":
            MessageLookupByLibrary.simpleMessage("Multi Outbound Support"),
        "multiOutboundSupportMsg": MessageLookupByLibrary.simpleMessage(
            "Multi outbound support, default off. Sing-Box does not support traffic statistics when this option is enabled"),
        "multipleCores": MessageLookupByLibrary.simpleMessage("Multiple Cores"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "nameEnterMsg":
            MessageLookupByLibrary.simpleMessage("Please enter a name"),
        "navigationStyle":
            MessageLookupByLibrary.simpleMessage("Navigation Style"),
        "navigationStyleMsg": MessageLookupByLibrary.simpleMessage(
            "Navigation style, default is rail"),
        "newVersionAvailable":
            MessageLookupByLibrary.simpleMessage("New version available"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noConfigurationFileGenerated": MessageLookupByLibrary.simpleMessage(
            "No configuration file generated"),
        "noLogsAvailable":
            MessageLookupByLibrary.simpleMessage("No logs available"),
        "noRunningCores":
            MessageLookupByLibrary.simpleMessage("No running cores"),
        "noServerSelected":
            MessageLookupByLibrary.simpleMessage("No server selected"),
        "numSubscriptionsHaveBeenUpdated": m5,
        "obfs": MessageLookupByLibrary.simpleMessage("obfs"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordEnterMsg":
            MessageLookupByLibrary.simpleMessage("Please enter a password"),
        "passwordMsg": MessageLookupByLibrary.simpleMessage(
            "Password for local server authentication"),
        "path": MessageLookupByLibrary.simpleMessage("Path"),
        "plugin": MessageLookupByLibrary.simpleMessage("Plugin"),
        "pluginOpts": MessageLookupByLibrary.simpleMessage("Plugin Options"),
        "port": MessageLookupByLibrary.simpleMessage("Port"),
        "portEnterMsg":
            MessageLookupByLibrary.simpleMessage("Please enter a port"),
        "portInvalidMsg": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid port number"),
        "publicKey": MessageLookupByLibrary.simpleMessage("PublicKey"),
        "publicKeyEnterMsg":
            MessageLookupByLibrary.simpleMessage("Please enter a PublicKey"),
        "qrCode": MessageLookupByLibrary.simpleMessage("QR Code"),
        "recvWindow": MessageLookupByLibrary.simpleMessage(
            "QUIC Connection Receive Window"),
        "recvWindowConn":
            MessageLookupByLibrary.simpleMessage("QUIC Stream Receive Window"),
        "recvWindowConnInvalidMsg": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid value of QUIC Stream Receive Window"),
        "recvWindowInvalidMsg": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid value of QUIC Connection Receive Window"),
        "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
        "remark": MessageLookupByLibrary.simpleMessage("Remark"),
        "remoteDns": MessageLookupByLibrary.simpleMessage("Remote DNS"),
        "remoteDnsMsg": MessageLookupByLibrary.simpleMessage(
            "Remote DNS, default is https://dns.google/dns-query. Sing-Box will attempt resolution before startup.\nIf you are not sure about the DNS format of the routing provider, please do not modify"),
        "reorderGroup": MessageLookupByLibrary.simpleMessage("Reorder Group"),
        "repoUrl": MessageLookupByLibrary.simpleMessage("Repo URL"),
        "resetRules": MessageLookupByLibrary.simpleMessage("Reset Rules"),
        "resetRulesConfirm": MessageLookupByLibrary.simpleMessage(
            "Are you sure to reset the rules?"),
        "routingProvider":
            MessageLookupByLibrary.simpleMessage("Routing Provider"),
        "routingProviderMsg": MessageLookupByLibrary.simpleMessage(
            "Routing provider, default is sing-box"),
        "rule": MessageLookupByLibrary.simpleMessage("Rule"),
        "ruleData": MessageLookupByLibrary.simpleMessage("Rule Data"),
        "rules": MessageLookupByLibrary.simpleMessage("Rules"),
        "runningCores": MessageLookupByLibrary.simpleMessage("Running Cores"),
        "runningServer": MessageLookupByLibrary.simpleMessage("Running Server"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "saveCoreLog": MessageLookupByLibrary.simpleMessage("Save Core Log"),
        "saveCoreLogMsg": MessageLookupByLibrary.simpleMessage(
            "Save core logs to the log directory"),
        "scanCores": MessageLookupByLibrary.simpleMessage("Scan Cores"),
        "scanCoresCompleted":
            MessageLookupByLibrary.simpleMessage("Scan Cores Completed"),
        "selectProtocol":
            MessageLookupByLibrary.simpleMessage("Select Protocol"),
        "selectedServer":
            MessageLookupByLibrary.simpleMessage("Selected Server"),
        "server": MessageLookupByLibrary.simpleMessage("Server"),
        "servers": MessageLookupByLibrary.simpleMessage("Servers"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "shadowsocksProvider":
            MessageLookupByLibrary.simpleMessage("Shadowsocks Provider"),
        "shadowsocksProviderMsg": MessageLookupByLibrary.simpleMessage(
            "Shadowsocks provider, default is sing-box"),
        "shortId": MessageLookupByLibrary.simpleMessage("ShortID"),
        "show": MessageLookupByLibrary.simpleMessage("Show"),
        "showAddress": MessageLookupByLibrary.simpleMessage("Show Address"),
        "showAddressMsg": MessageLookupByLibrary.simpleMessage(
            "Display address and port number on the server card"),
        "showTransport": MessageLookupByLibrary.simpleMessage("Show Transport"),
        "showTransportMsg": MessageLookupByLibrary.simpleMessage(
            "Display transport on the server card if available"),
        "singleCore": MessageLookupByLibrary.simpleMessage("Single Core"),
        "sni": MessageLookupByLibrary.simpleMessage("SNI"),
        "socksPort": MessageLookupByLibrary.simpleMessage("Socks Port"),
        "socksPortMsg": MessageLookupByLibrary.simpleMessage(
            "Socks port, only applicable to xray-core"),
        "speed": MessageLookupByLibrary.simpleMessage("Speed"),
        "spiderX": MessageLookupByLibrary.simpleMessage("SpiderX"),
        "stack": MessageLookupByLibrary.simpleMessage("Stack"),
        "stackMsg": MessageLookupByLibrary.simpleMessage(
            "Tun stack, default is system"),
        "startOnBoot": MessageLookupByLibrary.simpleMessage("Start on Boot"),
        "startOnBootMsg": MessageLookupByLibrary.simpleMessage(
            "Start on boot, supports Windows, Linux, MacOS"),
        "statisticsIsDisabled":
            MessageLookupByLibrary.simpleMessage("Statistics is disabled"),
        "stopCoreBeforeDelete": MessageLookupByLibrary.simpleMessage(
            "Please stop the core before deleting"),
        "strictRoute": MessageLookupByLibrary.simpleMessage("Strict Route"),
        "strictRouteMsg": MessageLookupByLibrary.simpleMessage(
            "Tun strict route, default off"),
        "subscription": MessageLookupByLibrary.simpleMessage("Subscription"),
        "systemProxy": MessageLookupByLibrary.simpleMessage("System Proxy"),
        "themeColor": MessageLookupByLibrary.simpleMessage("Theme Color"),
        "themeColorArgb":
            MessageLookupByLibrary.simpleMessage("Theme Color (A,R,G,B)"),
        "themeColorMsg": MessageLookupByLibrary.simpleMessage(
            "Change the theme color, default is Light Blue"),
        "themeColorWarn": MessageLookupByLibrary.simpleMessage(
            "ARGB values should be integers within the range [0, 256)"),
        "tls": MessageLookupByLibrary.simpleMessage("TLS"),
        "traffic": MessageLookupByLibrary.simpleMessage("Traffic"),
        "transport": MessageLookupByLibrary.simpleMessage("Transport"),
        "trojanProvider":
            MessageLookupByLibrary.simpleMessage("Trojan Provider"),
        "trojanProviderMsg": MessageLookupByLibrary.simpleMessage(
            "Trojan provider, default is sing-box"),
        "tunProvider": MessageLookupByLibrary.simpleMessage("Tun Provider"),
        "tunProviderMsg": MessageLookupByLibrary.simpleMessage(
            "Tun provider, default is sing-box"),
        "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
        "upMbps": MessageLookupByLibrary.simpleMessage("Up Mbps"),
        "upMbpsEnterMsg":
            MessageLookupByLibrary.simpleMessage("Please enter an Up Mbps"),
        "upMbpsInvalidMsg": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid Up Mbps"),
        "update": MessageLookupByLibrary.simpleMessage("Update"),
        "updateFailed":
            MessageLookupByLibrary.simpleMessage("Failed to update"),
        "updateGroup": MessageLookupByLibrary.simpleMessage("Update Group"),
        "updateGroupFailed":
            MessageLookupByLibrary.simpleMessage("Failed to update group"),
        "updateSubscriptionInterval": MessageLookupByLibrary.simpleMessage(
            "Update Subscription Interval (minutes)"),
        "updateSubscriptionIntervalMsg": MessageLookupByLibrary.simpleMessage(
            "Update subscription interval, default is -1 (never update)"),
        "updateSubscriptionIntervalWarn": MessageLookupByLibrary.simpleMessage(
            "Update subscription interval must be a positive integer or -1"),
        "updateThroughProxy":
            MessageLookupByLibrary.simpleMessage("Update Through Proxy"),
        "updateThroughProxyMsg": MessageLookupByLibrary.simpleMessage(
            "Update through proxy, default off. When it\'s on, updates for the core and subscriptions will be done through a proxy server (requires an active server)"),
        "updatedGroupSuccessfully":
            MessageLookupByLibrary.simpleMessage("Updated group successfully"),
        "updatedSuccessfully": m6,
        "upload": MessageLookupByLibrary.simpleMessage("Upload"),
        "uploadSpeed": MessageLookupByLibrary.simpleMessage("Upload Speed"),
        "useMaterial3": MessageLookupByLibrary.simpleMessage("Use Material 3"),
        "useMaterial3Msg":
            MessageLookupByLibrary.simpleMessage("Use Material 3, default off"),
        "user": MessageLookupByLibrary.simpleMessage("User"),
        "userAgent": MessageLookupByLibrary.simpleMessage("User-Agent"),
        "userAgentMsg": MessageLookupByLibrary.simpleMessage(
            "User-Agent, used for fetching subscriptions and HTTP protocol. Default is chrome"),
        "userMsg": MessageLookupByLibrary.simpleMessage(
            "Username for local server authentication"),
        "uuid": MessageLookupByLibrary.simpleMessage("UUID"),
        "uuidEnterMsg":
            MessageLookupByLibrary.simpleMessage("Please enter a UUID"),
        "vlessProvider": MessageLookupByLibrary.simpleMessage("Vless Provider"),
        "vlessProviderMsg": MessageLookupByLibrary.simpleMessage(
            "Vless provider, default is sing-box"),
        "vmessProvider": MessageLookupByLibrary.simpleMessage("VMess Provider"),
        "vmessProviderMsg": MessageLookupByLibrary.simpleMessage(
            "VMess provider, default is sing-box"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
