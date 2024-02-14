// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Add Group`
  String get addGroup {
    return Intl.message(
      'Add Group',
      name: 'addGroup',
      desc: '',
      args: [],
    );
  }

  /// `Add Server`
  String get addServer {
    return Intl.message(
      'Add Server',
      name: 'addServer',
      desc: '',
      args: [],
    );
  }

  /// `Additional Socks Port`
  String get additionalSocksPort {
    return Intl.message(
      'Additional Socks Port',
      name: 'additionalSocksPort',
      desc: '',
      args: [],
    );
  }

  /// `Additional Socks port used for communication between the routing provider and other core components. If not necessary, please avoid running multiple cores simultaneously`
  String get additionalSocksPortMsg {
    return Intl.message(
      'Additional Socks port used for communication between the routing provider and other core components. If not necessary, please avoid running multiple cores simultaneously',
      name: 'additionalSocksPortMsg',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an address`
  String get addressEnterMsg {
    return Intl.message(
      'Please enter an address',
      name: 'addressEnterMsg',
      desc: '',
      args: [],
    );
  }

  /// `All Groups`
  String get allGroups {
    return Intl.message(
      'All Groups',
      name: 'allGroups',
      desc: '',
      args: [],
    );
  }

  /// `Allow Insecure`
  String get allowInsecure {
    return Intl.message(
      'Allow Insecure',
      name: 'allowInsecure',
      desc: '',
      args: [],
    );
  }

  /// `ALPN`
  String get alpn {
    return Intl.message(
      'ALPN',
      name: 'alpn',
      desc: '',
      args: [],
    );
  }

  /// `Already latest version`
  String get alreadyLatestVersion {
    return Intl.message(
      'Already latest version',
      name: 'alreadyLatestVersion',
      desc: '',
      args: [],
    );
  }

  /// `Alter ID`
  String get alterId {
    return Intl.message(
      'Alter ID',
      name: 'alterId',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an Alter ID`
  String get alterIdEnterMsg {
    return Intl.message(
      'Please enter an Alter ID',
      name: 'alterIdEnterMsg',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid Alter ID`
  String get alterIdInvalidMsg {
    return Intl.message(
      'Please enter a valid Alter ID',
      name: 'alterIdInvalidMsg',
      desc: '',
      args: [],
    );
  }

  /// `Auth Payload`
  String get authPayload {
    return Intl.message(
      'Auth Payload',
      name: 'authPayload',
      desc: '',
      args: [],
    );
  }

  /// `Auth Type`
  String get authType {
    return Intl.message(
      'Auth Type',
      name: 'authType',
      desc: '',
      args: [],
    );
  }

  /// `Authentication`
  String get authentication {
    return Intl.message(
      'Authentication',
      name: 'authentication',
      desc: '',
      args: [],
    );
  }

  /// `Enable authentication for the local server`
  String get authenticationMsg {
    return Intl.message(
      'Enable authentication for the local server',
      name: 'authenticationMsg',
      desc: '',
      args: [],
    );
  }

  /// `Auto Enable System Proxy`
  String get autoConfigureSystemProxy {
    return Intl.message(
      'Auto Enable System Proxy',
      name: 'autoConfigureSystemProxy',
      desc: '',
      args: [],
    );
  }

  /// `Configure system proxy automatically when core starts or stops, default off`
  String get autoConfigureSystemProxyMsg {
    return Intl.message(
      'Configure system proxy automatically when core starts or stops, default off',
      name: 'autoConfigureSystemProxyMsg',
      desc: '',
      args: [],
    );
  }

  /// `Auto Get IP`
  String get autoGetIp {
    return Intl.message(
      'Auto Get IP',
      name: 'autoGetIp',
      desc: '',
      args: [],
    );
  }

  /// `Automatically get current IP, default off`
  String get autoGetIpMsg {
    return Intl.message(
      'Automatically get current IP, default off',
      name: 'autoGetIpMsg',
      desc: '',
      args: [],
    );
  }

  /// `Auto Route`
  String get autoRoute {
    return Intl.message(
      'Auto Route',
      name: 'autoRoute',
      desc: '',
      args: [],
    );
  }

  /// `Tun automatically configure routes, default on`
  String get autoRouteMsg {
    return Intl.message(
      'Tun automatically configure routes, default on',
      name: 'autoRouteMsg',
      desc: '',
      args: [],
    );
  }

  /// `Auto Run Server`
  String get autoRunServer {
    return Intl.message(
      'Auto Run Server',
      name: 'autoRunServer',
      desc: '',
      args: [],
    );
  }

  /// `Automatically run the last selected server when Sphia starts`
  String get autoRunServerMsg {
    return Intl.message(
      'Automatically run the last selected server when Sphia starts',
      name: 'autoRunServerMsg',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Cannot edit or delete group`
  String get cannotEditOrDeleteGroup {
    return Intl.message(
      'Cannot edit or delete group',
      name: 'cannotEditOrDeleteGroup',
      desc: '',
      args: [],
    );
  }

  /// `Check Update`
  String get checkUpdate {
    return Intl.message(
      'Check Update',
      name: 'checkUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Failed to check update`
  String get checkUpdateFailed {
    return Intl.message(
      'Failed to check update',
      name: 'checkUpdateFailed',
      desc: '',
      args: [],
    );
  }

  /// `Checking update`
  String get checkingUpdate {
    return Intl.message(
      'Checking update',
      name: 'checkingUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Clear Traffic`
  String get clearTraffic {
    return Intl.message(
      'Clear Traffic',
      name: 'clearTraffic',
      desc: '',
      args: [],
    );
  }

  /// `Configuration`
  String get configuration {
    return Intl.message(
      'Configuration',
      name: 'configuration',
      desc: '',
      args: [],
    );
  }

  /// `Configure DNS`
  String get configureDns {
    return Intl.message(
      'Configure DNS',
      name: 'configureDns',
      desc: '',
      args: [],
    );
  }

  /// `Configure DNS for the routing provider, default on. Currently only supports configuring remote and direct DNS. Please note the format of the address`
  String get configureDnsMsg {
    return Intl.message(
      'Configure DNS for the routing provider, default on. Currently only supports configuring remote and direct DNS. Please note the format of the address',
      name: 'configureDnsMsg',
      desc: '',
      args: [],
    );
  }

  /// `Failed to connect to Github`
  String get connectToGithubFailed {
    return Intl.message(
      'Failed to connect to Github',
      name: 'connectToGithubFailed',
      desc: '',
      args: [],
    );
  }

  /// `Core API Port`
  String get coreApiPort {
    return Intl.message(
      'Core API Port',
      name: 'coreApiPort',
      desc: '',
      args: [],
    );
  }

  /// `The port used for retrieving traffic statistics from the core API`
  String get coreApiPortMsg {
    return Intl.message(
      'The port used for retrieving traffic statistics from the core API',
      name: 'coreApiPortMsg',
      desc: '',
      args: [],
    );
  }

  /// `Core not found: {coreName}`
  String coreNotFound(Object coreName) {
    return Intl.message(
      'Core not found: $coreName',
      name: 'coreNotFound',
      desc: '',
      args: [coreName],
    );
  }

  /// `Start Core`
  String get coreStart {
    return Intl.message(
      'Start Core',
      name: 'coreStart',
      desc: '',
      args: [],
    );
  }

  /// `Failed to start core`
  String get coreStartFailed {
    return Intl.message(
      'Failed to start core',
      name: 'coreStartFailed',
      desc: '',
      args: [],
    );
  }

  /// `Stop Core`
  String get coreStop {
    return Intl.message(
      'Stop Core',
      name: 'coreStop',
      desc: '',
      args: [],
    );
  }

  /// `Current Group`
  String get currentGroup {
    return Intl.message(
      'Current Group',
      name: 'currentGroup',
      desc: '',
      args: [],
    );
  }

  /// `Current IP`
  String get currentIp {
    return Intl.message(
      'Current IP',
      name: 'currentIp',
      desc: '',
      args: [],
    );
  }

  /// `Current Version`
  String get currentVersion {
    return Intl.message(
      'Current Version',
      name: 'currentVersion',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message(
      'Dark Mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Enable dark mode, default on`
  String get darkModeMsg {
    return Intl.message(
      'Enable dark mode, default on',
      name: 'darkModeMsg',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message(
      'Dashboard',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete Core`
  String get deleteCore {
    return Intl.message(
      'Delete Core',
      name: 'deleteCore',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete the core {coreName}?`
  String deleteCoreConfirm(Object coreName) {
    return Intl.message(
      'Are you sure to delete the core $coreName?',
      name: 'deleteCoreConfirm',
      desc: '',
      args: [coreName],
    );
  }

  /// `Failed to delete core`
  String get deleteCoreFailed {
    return Intl.message(
      'Failed to delete core',
      name: 'deleteCoreFailed',
      desc: '',
      args: [],
    );
  }

  /// `Delete Group`
  String get deleteGroup {
    return Intl.message(
      'Delete Group',
      name: 'deleteGroup',
      desc: '',
      args: [],
    );
  }

  /// `Delete Server`
  String get deleteServer {
    return Intl.message(
      'Delete Server',
      name: 'deleteServer',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete the server {remark}?`
  String deleteServerConfirm(Object remark) {
    return Intl.message(
      'Are you sure to delete the server $remark?',
      name: 'deleteServerConfirm',
      desc: '',
      args: [remark],
    );
  }

  /// `Deleted {coreName} successfully`
  String deletedCoreSuccessfully(Object coreName) {
    return Intl.message(
      'Deleted $coreName successfully',
      name: 'deletedCoreSuccessfully',
      desc: '',
      args: [coreName],
    );
  }

  /// `Direct DNS`
  String get directDns {
    return Intl.message(
      'Direct DNS',
      name: 'directDns',
      desc: '',
      args: [],
    );
  }

  /// `Direct DNS, default is https+local://doh.pub/dns-query. Sing-Box will attempt resolution before startup.\nIf you are not sure about the DNS format of the routing provider, please do not modify`
  String get directDnsMsg {
    return Intl.message(
      'Direct DNS, default is https+local://doh.pub/dns-query. Sing-Box will attempt resolution before startup.\nIf you are not sure about the DNS format of the routing provider, please do not modify',
      name: 'directDnsMsg',
      desc: '',
      args: [],
    );
  }

  /// `Disable MTU Discovery`
  String get disableMtuDiscovery {
    return Intl.message(
      'Disable MTU Discovery',
      name: 'disableMtuDiscovery',
      desc: '',
      args: [],
    );
  }

  /// `DNS`
  String get dns {
    return Intl.message(
      'DNS',
      name: 'dns',
      desc: '',
      args: [],
    );
  }

  /// `DNS is not configured`
  String get dnsIsNotConfigured {
    return Intl.message(
      'DNS is not configured',
      name: 'dnsIsNotConfigured',
      desc: '',
      args: [],
    );
  }

  /// `Domain Matcher`
  String get domainMatcher {
    return Intl.message(
      'Domain Matcher',
      name: 'domainMatcher',
      desc: '',
      args: [],
    );
  }

  /// `Domain matcher, default is hybrid. Only applicable to xray-core`
  String get domainMatcherMsg {
    return Intl.message(
      'Domain matcher, default is hybrid. Only applicable to xray-core',
      name: 'domainMatcherMsg',
      desc: '',
      args: [],
    );
  }

  /// `Domain Strategy`
  String get domainStrategy {
    return Intl.message(
      'Domain Strategy',
      name: 'domainStrategy',
      desc: '',
      args: [],
    );
  }

  /// `Domain strategy, default is IPIfNonMatch. Only applicable to xray-core`
  String get domainStrategyMsg {
    return Intl.message(
      'Domain strategy, default is IPIfNonMatch. Only applicable to xray-core',
      name: 'domainStrategyMsg',
      desc: '',
      args: [],
    );
  }

  /// `Down Mbps`
  String get downMbps {
    return Intl.message(
      'Down Mbps',
      name: 'downMbps',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a Down Mbps`
  String get downMbpsEnterMsg {
    return Intl.message(
      'Please enter a Down Mbps',
      name: 'downMbpsEnterMsg',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid Down Mbps`
  String get downMbpsInvalidMsg {
    return Intl.message(
      'Please enter a valid Down Mbps',
      name: 'downMbpsInvalidMsg',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Download Speed`
  String get downloadSpeed {
    return Intl.message(
      'Download Speed',
      name: 'downloadSpeed',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Edit Group`
  String get editGroup {
    return Intl.message(
      'Edit Group',
      name: 'editGroup',
      desc: '',
      args: [],
    );
  }

  /// `Enable Core Log`
  String get enableCoreLog {
    return Intl.message(
      'Enable Core Log',
      name: 'enableCoreLog',
      desc: '',
      args: [],
    );
  }

  /// `Enable core logs, default on`
  String get enableCoreLogMsg {
    return Intl.message(
      'Enable core logs, default on',
      name: 'enableCoreLogMsg',
      desc: '',
      args: [],
    );
  }

  /// `Enable IPv4`
  String get enableIpv4 {
    return Intl.message(
      'Enable IPv4',
      name: 'enableIpv4',
      desc: '',
      args: [],
    );
  }

  /// `Enable IPv4 for Tun, enabled and cannot be changed`
  String get enableIpv4Msg {
    return Intl.message(
      'Enable IPv4 for Tun, enabled and cannot be changed',
      name: 'enableIpv4Msg',
      desc: '',
      args: [],
    );
  }

  /// `Enable IPv6`
  String get enableIpv6 {
    return Intl.message(
      'Enable IPv6',
      name: 'enableIpv6',
      desc: '',
      args: [],
    );
  }

  /// `Enable IPv6 for Tun`
  String get enableIpv6Msg {
    return Intl.message(
      'Enable IPv6 for Tun',
      name: 'enableIpv6Msg',
      desc: '',
      args: [],
    );
  }

  /// `Enable Sniffing`
  String get enableSniffing {
    return Intl.message(
      'Enable Sniffing',
      name: 'enableSniffing',
      desc: '',
      args: [],
    );
  }

  /// `Enable traffic sniffing, default on`
  String get enableSniffingMsg {
    return Intl.message(
      'Enable traffic sniffing, default on',
      name: 'enableSniffingMsg',
      desc: '',
      args: [],
    );
  }

  /// `Enable Speed Chart`
  String get enableSpeedChart {
    return Intl.message(
      'Enable Speed Chart',
      name: 'enableSpeedChart',
      desc: '',
      args: [],
    );
  }

  /// `Enable speed chart, default off`
  String get enableSpeedChartMsg {
    return Intl.message(
      'Enable speed chart, default off',
      name: 'enableSpeedChartMsg',
      desc: '',
      args: [],
    );
  }

  /// `Enable Statistics`
  String get enableStatistics {
    return Intl.message(
      'Enable Statistics',
      name: 'enableStatistics',
      desc: '',
      args: [],
    );
  }

  /// `Enable statistics, default off. When turned on, it will track the traffic and display speed on the dashboard`
  String get enableStatisticsMsg {
    return Intl.message(
      'Enable statistics, default off. When turned on, it will track the traffic and display speed on the dashboard',
      name: 'enableStatisticsMsg',
      desc: '',
      args: [],
    );
  }

  /// `Enable Tun`
  String get enableTun {
    return Intl.message(
      'Enable Tun',
      name: 'enableTun',
      desc: '',
      args: [],
    );
  }

  /// `Enable Tun, requires administrator privileges`
  String get enableTunMsg {
    return Intl.message(
      'Enable Tun, requires administrator privileges',
      name: 'enableTunMsg',
      desc: '',
      args: [],
    );
  }

  /// `Enable UDP`
  String get enableUdp {
    return Intl.message(
      'Enable UDP',
      name: 'enableUdp',
      desc: '',
      args: [],
    );
  }

  /// `Enable UDP, only applicable to local Socks server`
  String get enableUdpMsg {
    return Intl.message(
      'Enable UDP, only applicable to local Socks server',
      name: 'enableUdpMsg',
      desc: '',
      args: [],
    );
  }

  /// `Encryption`
  String get encryption {
    return Intl.message(
      'Encryption',
      name: 'encryption',
      desc: '',
      args: [],
    );
  }

  /// `Endpoint Independent NAT`
  String get endpointIndependentNat {
    return Intl.message(
      'Endpoint Independent NAT',
      name: 'endpointIndependentNat',
      desc: '',
      args: [],
    );
  }

  /// `Endpoint Independent NAT, default off`
  String get endpointIndependentNatMsg {
    return Intl.message(
      'Endpoint Independent NAT, default off',
      name: 'endpointIndependentNatMsg',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid number`
  String get enterValidNumberMsg {
    return Intl.message(
      'Please enter a valid number',
      name: 'enterValidNumberMsg',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Export to Clipboard`
  String get exportToClipboard {
    return Intl.message(
      'Export to Clipboard',
      name: 'exportToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Export to File`
  String get exportToFile {
    return Intl.message(
      'Export to File',
      name: 'exportToFile',
      desc: '',
      args: [],
    );
  }

  /// `Fetch Subscription`
  String get fetchSubscription {
    return Intl.message(
      'Fetch Subscription',
      name: 'fetchSubscription',
      desc: '',
      args: [],
    );
  }

  /// `FingerPrint`
  String get fingerPrint {
    return Intl.message(
      'FingerPrint',
      name: 'fingerPrint',
      desc: '',
      args: [],
    );
  }

  /// `Flow`
  String get flow {
    return Intl.message(
      'Flow',
      name: 'flow',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get IP`
  String get getIpFailed {
    return Intl.message(
      'Failed to get IP',
      name: 'getIpFailed',
      desc: '',
      args: [],
    );
  }

  /// `Getting IP`
  String get gettingIp {
    return Intl.message(
      'Getting IP',
      name: 'gettingIp',
      desc: '',
      args: [],
    );
  }

  /// `Group has no subscription`
  String get groupHasNoSubscription {
    return Intl.message(
      'Group has no subscription',
      name: 'groupHasNoSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Group Name`
  String get groupName {
    return Intl.message(
      'Group Name',
      name: 'groupName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a group name`
  String get groupNameEnterMsg {
    return Intl.message(
      'Please enter a group name',
      name: 'groupNameEnterMsg',
      desc: '',
      args: [],
    );
  }

  /// `gRPC Mode`
  String get grpcMode {
    return Intl.message(
      'gRPC Mode',
      name: 'grpcMode',
      desc: '',
      args: [],
    );
  }

  /// `gRPC Service Name`
  String get grpcServiceName {
    return Intl.message(
      'gRPC Service Name',
      name: 'grpcServiceName',
      desc: '',
      args: [],
    );
  }

  /// `Hide`
  String get hide {
    return Intl.message(
      'Hide',
      name: 'hide',
      desc: '',
      args: [],
    );
  }

  /// `Host`
  String get host {
    return Intl.message(
      'Host',
      name: 'host',
      desc: '',
      args: [],
    );
  }

  /// `HTTP Port`
  String get httpPort {
    return Intl.message(
      'HTTP Port',
      name: 'httpPort',
      desc: '',
      args: [],
    );
  }

  /// `HTTP port, only applicable to xray-core`
  String get httpPortMsg {
    return Intl.message(
      'HTTP port, only applicable to xray-core',
      name: 'httpPortMsg',
      desc: '',
      args: [],
    );
  }

  /// `Hysteria Protocol`
  String get hysteriaProtocol {
    return Intl.message(
      'Hysteria Protocol',
      name: 'hysteriaProtocol',
      desc: '',
      args: [],
    );
  }

  /// `Hysteria Provider`
  String get hysteriaProvider {
    return Intl.message(
      'Hysteria Provider',
      name: 'hysteriaProvider',
      desc: '',
      args: [],
    );
  }

  /// `Hysteria provider, default is sing-box`
  String get hysteriaProviderMsg {
    return Intl.message(
      'Hysteria provider, default is sing-box',
      name: 'hysteriaProviderMsg',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get import {
    return Intl.message(
      'Import',
      name: 'import',
      desc: '',
      args: [],
    );
  }

  /// `Failed to import core`
  String get importCoreFailed {
    return Intl.message(
      'Failed to import core',
      name: 'importCoreFailed',
      desc: '',
      args: [],
    );
  }

  /// `Imported core successfully`
  String get importCoreSuccessfully {
    return Intl.message(
      'Imported core successfully',
      name: 'importCoreSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Import from Clipboard`
  String get importFromClipboard {
    return Intl.message(
      'Import from Clipboard',
      name: 'importFromClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Selected cores or rule data have been copied to {binPath}, and cores will be scanned automatically. The version number of the rule data cannot be obtained`
  String importMultiCoresMsg(Object binPath) {
    return Intl.message(
      'Selected cores or rule data have been copied to $binPath, and cores will be scanned automatically. The version number of the rule data cannot be obtained',
      name: 'importMultiCoresMsg',
      desc: '',
      args: [binPath],
    );
  }

  /// `IPv4 Address`
  String get ipv4Address {
    return Intl.message(
      'IPv4 Address',
      name: 'ipv4Address',
      desc: '',
      args: [],
    );
  }

  /// `Tun IPv4 address`
  String get ipv4AddressMsg {
    return Intl.message(
      'Tun IPv4 address',
      name: 'ipv4AddressMsg',
      desc: '',
      args: [],
    );
  }

  /// `IPv6 Address`
  String get ipv6Address {
    return Intl.message(
      'IPv6 Address',
      name: 'ipv6Address',
      desc: '',
      args: [],
    );
  }

  /// `Tun IPv6 address`
  String get ipv6AddressMsg {
    return Intl.message(
      'Tun IPv6 address',
      name: 'ipv6AddressMsg',
      desc: '',
      args: [],
    );
  }

  /// `Latest Version`
  String get latestVersion {
    return Intl.message(
      'Latest Version',
      name: 'latestVersion',
      desc: '',
      args: [],
    );
  }

  /// `Failed to launch URL`
  String get launchUrlFailed {
    return Intl.message(
      'Failed to launch URL',
      name: 'launchUrlFailed',
      desc: '',
      args: [],
    );
  }

  /// `Listen`
  String get listen {
    return Intl.message(
      'Listen',
      name: 'listen',
      desc: '',
      args: [],
    );
  }

  /// `Local server listening address, default is 127.0.0.1`
  String get listenMsg {
    return Intl.message(
      'Local server listening address, default is 127.0.0.1',
      name: 'listenMsg',
      desc: '',
      args: [],
    );
  }

  /// `Log`
  String get log {
    return Intl.message(
      'Log',
      name: 'log',
      desc: '',
      args: [],
    );
  }

  /// `Log Level`
  String get logLevel {
    return Intl.message(
      'Log Level',
      name: 'logLevel',
      desc: '',
      args: [],
    );
  }

  /// `Log level, default is warning`
  String get logLevelMsg {
    return Intl.message(
      'Log level, default is warning',
      name: 'logLevelMsg',
      desc: '',
      args: [],
    );
  }

  /// `Max Log Count`
  String get maxLogCount {
    return Intl.message(
      'Max Log Count',
      name: 'maxLogCount',
      desc: '',
      args: [],
    );
  }

  /// `Maximum number of logs displayed, default is 64`
  String get maxLogCountMsg {
    return Intl.message(
      'Maximum number of logs displayed, default is 64',
      name: 'maxLogCountMsg',
      desc: '',
      args: [],
    );
  }

  /// `Mixed Port`
  String get mixedPort {
    return Intl.message(
      'Mixed Port',
      name: 'mixedPort',
      desc: '',
      args: [],
    );
  }

  /// `Mixed port, only applicable to sing-box`
  String get mixedPortMsg {
    return Intl.message(
      'Mixed port, only applicable to sing-box',
      name: 'mixedPortMsg',
      desc: '',
      args: [],
    );
  }

  /// `MTU`
  String get mtu {
    return Intl.message(
      'MTU',
      name: 'mtu',
      desc: '',
      args: [],
    );
  }

  /// `Tun MTU, default is 9000`
  String get mtuMsg {
    return Intl.message(
      'Tun MTU, default is 9000',
      name: 'mtuMsg',
      desc: '',
      args: [],
    );
  }

  /// `Multi Outbound Support`
  String get multiOutboundSupport {
    return Intl.message(
      'Multi Outbound Support',
      name: 'multiOutboundSupport',
      desc: '',
      args: [],
    );
  }

  /// `Multi outbound support, default off. Sing-Box does not support traffic statistics when this option is enabled`
  String get multiOutboundSupportMsg {
    return Intl.message(
      'Multi outbound support, default off. Sing-Box does not support traffic statistics when this option is enabled',
      name: 'multiOutboundSupportMsg',
      desc: '',
      args: [],
    );
  }

  /// `Multiple Cores`
  String get multipleCores {
    return Intl.message(
      'Multiple Cores',
      name: 'multipleCores',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a name`
  String get nameEnterMsg {
    return Intl.message(
      'Please enter a name',
      name: 'nameEnterMsg',
      desc: '',
      args: [],
    );
  }

  /// `Navigation Style`
  String get navigationStyle {
    return Intl.message(
      'Navigation Style',
      name: 'navigationStyle',
      desc: '',
      args: [],
    );
  }

  /// `Navigation style, default is rail`
  String get navigationStyleMsg {
    return Intl.message(
      'Navigation style, default is rail',
      name: 'navigationStyleMsg',
      desc: '',
      args: [],
    );
  }

  /// `New version available`
  String get newVersionAvailable {
    return Intl.message(
      'New version available',
      name: 'newVersionAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `No configuration file generated`
  String get noConfigurationFileGenerated {
    return Intl.message(
      'No configuration file generated',
      name: 'noConfigurationFileGenerated',
      desc: '',
      args: [],
    );
  }

  /// `No logs available`
  String get noLogsAvailable {
    return Intl.message(
      'No logs available',
      name: 'noLogsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No running cores`
  String get noRunningCores {
    return Intl.message(
      'No running cores',
      name: 'noRunningCores',
      desc: '',
      args: [],
    );
  }

  /// `No server selected`
  String get noServerSelected {
    return Intl.message(
      'No server selected',
      name: 'noServerSelected',
      desc: '',
      args: [],
    );
  }

  /// `{count}/{total} subscriptions have been updated`
  String numSubscriptionsHaveBeenUpdated(Object count, Object total) {
    return Intl.message(
      '$count/$total subscriptions have been updated',
      name: 'numSubscriptionsHaveBeenUpdated',
      desc: '',
      args: [count, total],
    );
  }

  /// `obfs`
  String get obfs {
    return Intl.message(
      'obfs',
      name: 'obfs',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get passwordEnterMsg {
    return Intl.message(
      'Please enter a password',
      name: 'passwordEnterMsg',
      desc: '',
      args: [],
    );
  }

  /// `Password for local server authentication`
  String get passwordMsg {
    return Intl.message(
      'Password for local server authentication',
      name: 'passwordMsg',
      desc: '',
      args: [],
    );
  }

  /// `Path`
  String get path {
    return Intl.message(
      'Path',
      name: 'path',
      desc: '',
      args: [],
    );
  }

  /// `Plugin`
  String get plugin {
    return Intl.message(
      'Plugin',
      name: 'plugin',
      desc: '',
      args: [],
    );
  }

  /// `Plugin Options`
  String get pluginOpts {
    return Intl.message(
      'Plugin Options',
      name: 'pluginOpts',
      desc: '',
      args: [],
    );
  }

  /// `Port`
  String get port {
    return Intl.message(
      'Port',
      name: 'port',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a port`
  String get portEnterMsg {
    return Intl.message(
      'Please enter a port',
      name: 'portEnterMsg',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid port number`
  String get portInvalidMsg {
    return Intl.message(
      'Please enter a valid port number',
      name: 'portInvalidMsg',
      desc: '',
      args: [],
    );
  }

  /// `PublicKey`
  String get publicKey {
    return Intl.message(
      'PublicKey',
      name: 'publicKey',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a PublicKey`
  String get publicKeyEnterMsg {
    return Intl.message(
      'Please enter a PublicKey',
      name: 'publicKeyEnterMsg',
      desc: '',
      args: [],
    );
  }

  /// `QR Code`
  String get qrCode {
    return Intl.message(
      'QR Code',
      name: 'qrCode',
      desc: '',
      args: [],
    );
  }

  /// `QUIC Connection Receive Window`
  String get recvWindow {
    return Intl.message(
      'QUIC Connection Receive Window',
      name: 'recvWindow',
      desc: '',
      args: [],
    );
  }

  /// `QUIC Stream Receive Window`
  String get recvWindowConn {
    return Intl.message(
      'QUIC Stream Receive Window',
      name: 'recvWindowConn',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid value of QUIC Stream Receive Window`
  String get recvWindowConnInvalidMsg {
    return Intl.message(
      'Please enter a valid value of QUIC Stream Receive Window',
      name: 'recvWindowConnInvalidMsg',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid value of QUIC Connection Receive Window`
  String get recvWindowInvalidMsg {
    return Intl.message(
      'Please enter a valid value of QUIC Connection Receive Window',
      name: 'recvWindowInvalidMsg',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Remark`
  String get remark {
    return Intl.message(
      'Remark',
      name: 'remark',
      desc: '',
      args: [],
    );
  }

  /// `Remote DNS`
  String get remoteDns {
    return Intl.message(
      'Remote DNS',
      name: 'remoteDns',
      desc: '',
      args: [],
    );
  }

  /// `Remote DNS, default is https://dns.google/dns-query. Sing-Box will attempt resolution before startup.\nIf you are not sure about the DNS format of the routing provider, please do not modify`
  String get remoteDnsMsg {
    return Intl.message(
      'Remote DNS, default is https://dns.google/dns-query. Sing-Box will attempt resolution before startup.\nIf you are not sure about the DNS format of the routing provider, please do not modify',
      name: 'remoteDnsMsg',
      desc: '',
      args: [],
    );
  }

  /// `Reorder Group`
  String get reorderGroup {
    return Intl.message(
      'Reorder Group',
      name: 'reorderGroup',
      desc: '',
      args: [],
    );
  }

  /// `Repo URL`
  String get repoUrl {
    return Intl.message(
      'Repo URL',
      name: 'repoUrl',
      desc: '',
      args: [],
    );
  }

  /// `Reset Rules`
  String get resetRules {
    return Intl.message(
      'Reset Rules',
      name: 'resetRules',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to reset the rules?`
  String get resetRulesConfirm {
    return Intl.message(
      'Are you sure to reset the rules?',
      name: 'resetRulesConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Routing Provider`
  String get routingProvider {
    return Intl.message(
      'Routing Provider',
      name: 'routingProvider',
      desc: '',
      args: [],
    );
  }

  /// `Routing provider, default is sing-box`
  String get routingProviderMsg {
    return Intl.message(
      'Routing provider, default is sing-box',
      name: 'routingProviderMsg',
      desc: '',
      args: [],
    );
  }

  /// `Rule`
  String get rule {
    return Intl.message(
      'Rule',
      name: 'rule',
      desc: '',
      args: [],
    );
  }

  /// `Rule Data`
  String get ruleData {
    return Intl.message(
      'Rule Data',
      name: 'ruleData',
      desc: '',
      args: [],
    );
  }

  /// `Rules`
  String get rules {
    return Intl.message(
      'Rules',
      name: 'rules',
      desc: '',
      args: [],
    );
  }

  /// `Running Cores`
  String get runningCores {
    return Intl.message(
      'Running Cores',
      name: 'runningCores',
      desc: '',
      args: [],
    );
  }

  /// `Running Server`
  String get runningServer {
    return Intl.message(
      'Running Server',
      name: 'runningServer',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Save Core Log`
  String get saveCoreLog {
    return Intl.message(
      'Save Core Log',
      name: 'saveCoreLog',
      desc: '',
      args: [],
    );
  }

  /// `Save core logs to the log directory`
  String get saveCoreLogMsg {
    return Intl.message(
      'Save core logs to the log directory',
      name: 'saveCoreLogMsg',
      desc: '',
      args: [],
    );
  }

  /// `Scan Cores`
  String get scanCores {
    return Intl.message(
      'Scan Cores',
      name: 'scanCores',
      desc: '',
      args: [],
    );
  }

  /// `Scan Cores Completed`
  String get scanCoresCompleted {
    return Intl.message(
      'Scan Cores Completed',
      name: 'scanCoresCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Select Protocol`
  String get selectProtocol {
    return Intl.message(
      'Select Protocol',
      name: 'selectProtocol',
      desc: '',
      args: [],
    );
  }

  /// `Selected Server`
  String get selectedServer {
    return Intl.message(
      'Selected Server',
      name: 'selectedServer',
      desc: '',
      args: [],
    );
  }

  /// `Server`
  String get server {
    return Intl.message(
      'Server',
      name: 'server',
      desc: '',
      args: [],
    );
  }

  /// `Servers`
  String get servers {
    return Intl.message(
      'Servers',
      name: 'servers',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Shadowsocks Provider`
  String get shadowsocksProvider {
    return Intl.message(
      'Shadowsocks Provider',
      name: 'shadowsocksProvider',
      desc: '',
      args: [],
    );
  }

  /// `Shadowsocks provider, default is sing-box`
  String get shadowsocksProviderMsg {
    return Intl.message(
      'Shadowsocks provider, default is sing-box',
      name: 'shadowsocksProviderMsg',
      desc: '',
      args: [],
    );
  }

  /// `ShortID`
  String get shortId {
    return Intl.message(
      'ShortID',
      name: 'shortId',
      desc: '',
      args: [],
    );
  }

  /// `Show`
  String get show {
    return Intl.message(
      'Show',
      name: 'show',
      desc: '',
      args: [],
    );
  }

  /// `Show Address`
  String get showAddress {
    return Intl.message(
      'Show Address',
      name: 'showAddress',
      desc: '',
      args: [],
    );
  }

  /// `Display address and port number on the server card`
  String get showAddressMsg {
    return Intl.message(
      'Display address and port number on the server card',
      name: 'showAddressMsg',
      desc: '',
      args: [],
    );
  }

  /// `Show Transport`
  String get showTransport {
    return Intl.message(
      'Show Transport',
      name: 'showTransport',
      desc: '',
      args: [],
    );
  }

  /// `Display transport on the server card if available`
  String get showTransportMsg {
    return Intl.message(
      'Display transport on the server card if available',
      name: 'showTransportMsg',
      desc: '',
      args: [],
    );
  }

  /// `Single Core`
  String get singleCore {
    return Intl.message(
      'Single Core',
      name: 'singleCore',
      desc: '',
      args: [],
    );
  }

  /// `SNI`
  String get sni {
    return Intl.message(
      'SNI',
      name: 'sni',
      desc: '',
      args: [],
    );
  }

  /// `Socks Port`
  String get socksPort {
    return Intl.message(
      'Socks Port',
      name: 'socksPort',
      desc: '',
      args: [],
    );
  }

  /// `Socks port, only applicable to xray-core`
  String get socksPortMsg {
    return Intl.message(
      'Socks port, only applicable to xray-core',
      name: 'socksPortMsg',
      desc: '',
      args: [],
    );
  }

  /// `Speed`
  String get speed {
    return Intl.message(
      'Speed',
      name: 'speed',
      desc: '',
      args: [],
    );
  }

  /// `SpiderX`
  String get spiderX {
    return Intl.message(
      'SpiderX',
      name: 'spiderX',
      desc: '',
      args: [],
    );
  }

  /// `Stack`
  String get stack {
    return Intl.message(
      'Stack',
      name: 'stack',
      desc: '',
      args: [],
    );
  }

  /// `Tun stack, default is system`
  String get stackMsg {
    return Intl.message(
      'Tun stack, default is system',
      name: 'stackMsg',
      desc: '',
      args: [],
    );
  }

  /// `Start on Boot`
  String get startOnBoot {
    return Intl.message(
      'Start on Boot',
      name: 'startOnBoot',
      desc: '',
      args: [],
    );
  }

  /// `Start on boot, supports Windows, Linux, MacOS`
  String get startOnBootMsg {
    return Intl.message(
      'Start on boot, supports Windows, Linux, MacOS',
      name: 'startOnBootMsg',
      desc: '',
      args: [],
    );
  }

  /// `Statistics is disabled`
  String get statisticsIsDisabled {
    return Intl.message(
      'Statistics is disabled',
      name: 'statisticsIsDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Please stop the core before deleting`
  String get stopCoreBeforeDelete {
    return Intl.message(
      'Please stop the core before deleting',
      name: 'stopCoreBeforeDelete',
      desc: '',
      args: [],
    );
  }

  /// `Strict Route`
  String get strictRoute {
    return Intl.message(
      'Strict Route',
      name: 'strictRoute',
      desc: '',
      args: [],
    );
  }

  /// `Tun strict route, default off`
  String get strictRouteMsg {
    return Intl.message(
      'Tun strict route, default off',
      name: 'strictRouteMsg',
      desc: '',
      args: [],
    );
  }

  /// `Subscription`
  String get subscription {
    return Intl.message(
      'Subscription',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `System Proxy`
  String get systemProxy {
    return Intl.message(
      'System Proxy',
      name: 'systemProxy',
      desc: '',
      args: [],
    );
  }

  /// `Theme Color`
  String get themeColor {
    return Intl.message(
      'Theme Color',
      name: 'themeColor',
      desc: '',
      args: [],
    );
  }

  /// `Theme Color (A,R,G,B)`
  String get themeColorArgb {
    return Intl.message(
      'Theme Color (A,R,G,B)',
      name: 'themeColorArgb',
      desc: '',
      args: [],
    );
  }

  /// `Change the theme color, default is Light Blue`
  String get themeColorMsg {
    return Intl.message(
      'Change the theme color, default is Light Blue',
      name: 'themeColorMsg',
      desc: '',
      args: [],
    );
  }

  /// `ARGB values should be integers within the range [0, 256)`
  String get themeColorWarn {
    return Intl.message(
      'ARGB values should be integers within the range [0, 256)',
      name: 'themeColorWarn',
      desc: '',
      args: [],
    );
  }

  /// `TLS`
  String get tls {
    return Intl.message(
      'TLS',
      name: 'tls',
      desc: '',
      args: [],
    );
  }

  /// `Traffic`
  String get traffic {
    return Intl.message(
      'Traffic',
      name: 'traffic',
      desc: '',
      args: [],
    );
  }

  /// `Transport`
  String get transport {
    return Intl.message(
      'Transport',
      name: 'transport',
      desc: '',
      args: [],
    );
  }

  /// `Trojan Provider`
  String get trojanProvider {
    return Intl.message(
      'Trojan Provider',
      name: 'trojanProvider',
      desc: '',
      args: [],
    );
  }

  /// `Trojan provider, default is sing-box`
  String get trojanProviderMsg {
    return Intl.message(
      'Trojan provider, default is sing-box',
      name: 'trojanProviderMsg',
      desc: '',
      args: [],
    );
  }

  /// `Tun Provider`
  String get tunProvider {
    return Intl.message(
      'Tun Provider',
      name: 'tunProvider',
      desc: '',
      args: [],
    );
  }

  /// `Tun provider, default is sing-box`
  String get tunProviderMsg {
    return Intl.message(
      'Tun provider, default is sing-box',
      name: 'tunProviderMsg',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Up Mbps`
  String get upMbps {
    return Intl.message(
      'Up Mbps',
      name: 'upMbps',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an Up Mbps`
  String get upMbpsEnterMsg {
    return Intl.message(
      'Please enter an Up Mbps',
      name: 'upMbpsEnterMsg',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid Up Mbps`
  String get upMbpsInvalidMsg {
    return Intl.message(
      'Please enter a valid Up Mbps',
      name: 'upMbpsInvalidMsg',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update`
  String get updateFailed {
    return Intl.message(
      'Failed to update',
      name: 'updateFailed',
      desc: '',
      args: [],
    );
  }

  /// `Update Group`
  String get updateGroup {
    return Intl.message(
      'Update Group',
      name: 'updateGroup',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update group`
  String get updateGroupFailed {
    return Intl.message(
      'Failed to update group',
      name: 'updateGroupFailed',
      desc: '',
      args: [],
    );
  }

  /// `Update Subscription Interval (minutes)`
  String get updateSubscriptionInterval {
    return Intl.message(
      'Update Subscription Interval (minutes)',
      name: 'updateSubscriptionInterval',
      desc: '',
      args: [],
    );
  }

  /// `Update subscription interval, default is -1 (never update)`
  String get updateSubscriptionIntervalMsg {
    return Intl.message(
      'Update subscription interval, default is -1 (never update)',
      name: 'updateSubscriptionIntervalMsg',
      desc: '',
      args: [],
    );
  }

  /// `Update subscription interval must be a positive integer or -1`
  String get updateSubscriptionIntervalWarn {
    return Intl.message(
      'Update subscription interval must be a positive integer or -1',
      name: 'updateSubscriptionIntervalWarn',
      desc: '',
      args: [],
    );
  }

  /// `Update Through Proxy`
  String get updateThroughProxy {
    return Intl.message(
      'Update Through Proxy',
      name: 'updateThroughProxy',
      desc: '',
      args: [],
    );
  }

  /// `Update through proxy, default off. When it's on, updates for the core and subscriptions will be done through a proxy server (requires an active server)`
  String get updateThroughProxyMsg {
    return Intl.message(
      'Update through proxy, default off. When it\'s on, updates for the core and subscriptions will be done through a proxy server (requires an active server)',
      name: 'updateThroughProxyMsg',
      desc: '',
      args: [],
    );
  }

  /// `Updated group successfully`
  String get updatedGroupSuccessfully {
    return Intl.message(
      'Updated group successfully',
      name: 'updatedGroupSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Updated {coreName} to {version} successfully`
  String updatedSuccessfully(Object coreName, Object version) {
    return Intl.message(
      'Updated $coreName to $version successfully',
      name: 'updatedSuccessfully',
      desc: '',
      args: [coreName, version],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Upload Speed`
  String get uploadSpeed {
    return Intl.message(
      'Upload Speed',
      name: 'uploadSpeed',
      desc: '',
      args: [],
    );
  }

  /// `Use Material 3`
  String get useMaterial3 {
    return Intl.message(
      'Use Material 3',
      name: 'useMaterial3',
      desc: '',
      args: [],
    );
  }

  /// `Use Material 3, default off`
  String get useMaterial3Msg {
    return Intl.message(
      'Use Material 3, default off',
      name: 'useMaterial3Msg',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `User-Agent`
  String get userAgent {
    return Intl.message(
      'User-Agent',
      name: 'userAgent',
      desc: '',
      args: [],
    );
  }

  /// `User-Agent, used for fetching subscriptions and HTTP protocol. Default is chrome`
  String get userAgentMsg {
    return Intl.message(
      'User-Agent, used for fetching subscriptions and HTTP protocol. Default is chrome',
      name: 'userAgentMsg',
      desc: '',
      args: [],
    );
  }

  /// `Username for local server authentication`
  String get userMsg {
    return Intl.message(
      'Username for local server authentication',
      name: 'userMsg',
      desc: '',
      args: [],
    );
  }

  /// `UUID`
  String get uuid {
    return Intl.message(
      'UUID',
      name: 'uuid',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a UUID`
  String get uuidEnterMsg {
    return Intl.message(
      'Please enter a UUID',
      name: 'uuidEnterMsg',
      desc: '',
      args: [],
    );
  }

  /// `Vless Provider`
  String get vlessProvider {
    return Intl.message(
      'Vless Provider',
      name: 'vlessProvider',
      desc: '',
      args: [],
    );
  }

  /// `Vless provider, default is sing-box`
  String get vlessProviderMsg {
    return Intl.message(
      'Vless provider, default is sing-box',
      name: 'vlessProviderMsg',
      desc: '',
      args: [],
    );
  }

  /// `VMess Provider`
  String get vmessProvider {
    return Intl.message(
      'VMess Provider',
      name: 'vmessProvider',
      desc: '',
      args: [],
    );
  }

  /// `VMess provider, default is sing-box`
  String get vmessProviderMsg {
    return Intl.message(
      'VMess provider, default is sing-box',
      name: 'vmessProviderMsg',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
