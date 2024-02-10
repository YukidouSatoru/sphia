// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ConfigTable extends Config with TableInfo<$ConfigTable, ConfigData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfigTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _configMeta = const VerificationMeta('config');
  @override
  late final GeneratedColumn<String> config = GeneratedColumn<String>(
      'config', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, config];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'config';
  @override
  VerificationContext validateIntegrity(Insertable<ConfigData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('config')) {
      context.handle(_configMeta,
          config.isAcceptableOrUnknown(data['config']!, _configMeta));
    } else if (isInserting) {
      context.missing(_configMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfigData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfigData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      config: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}config'])!,
    );
  }

  @override
  $ConfigTable createAlias(String alias) {
    return $ConfigTable(attachedDatabase, alias);
  }
}

class ConfigData extends DataClass implements Insertable<ConfigData> {
  final int id;
  final String config;
  const ConfigData({required this.id, required this.config});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['config'] = Variable<String>(config);
    return map;
  }

  ConfigCompanion toCompanion(bool nullToAbsent) {
    return ConfigCompanion(
      id: Value(id),
      config: Value(config),
    );
  }

  factory ConfigData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfigData(
      id: serializer.fromJson<int>(json['id']),
      config: serializer.fromJson<String>(json['config']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'config': serializer.toJson<String>(config),
    };
  }

  ConfigData copyWith({int? id, String? config}) => ConfigData(
        id: id ?? this.id,
        config: config ?? this.config,
      );
  @override
  String toString() {
    return (StringBuffer('ConfigData(')
          ..write('id: $id, ')
          ..write('config: $config')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, config);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfigData &&
          other.id == this.id &&
          other.config == this.config);
}

class ConfigCompanion extends UpdateCompanion<ConfigData> {
  final Value<int> id;
  final Value<String> config;
  const ConfigCompanion({
    this.id = const Value.absent(),
    this.config = const Value.absent(),
  });
  ConfigCompanion.insert({
    this.id = const Value.absent(),
    required String config,
  }) : config = Value(config);
  static Insertable<ConfigData> custom({
    Expression<int>? id,
    Expression<String>? config,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (config != null) 'config': config,
    });
  }

  ConfigCompanion copyWith({Value<int>? id, Value<String>? config}) {
    return ConfigCompanion(
      id: id ?? this.id,
      config: config ?? this.config,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (config.present) {
      map['config'] = Variable<String>(config.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfigCompanion(')
          ..write('id: $id, ')
          ..write('config: $config')
          ..write(')'))
        .toString();
  }
}

class $ServerGroupsTable extends ServerGroups
    with TableInfo<$ServerGroupsTable, ServerGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServerGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subscriptionMeta =
      const VerificationMeta('subscription');
  @override
  late final GeneratedColumn<String> subscription = GeneratedColumn<String>(
      'subscription', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, subscription];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'server_groups';
  @override
  VerificationContext validateIntegrity(Insertable<ServerGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('subscription')) {
      context.handle(
          _subscriptionMeta,
          subscription.isAcceptableOrUnknown(
              data['subscription']!, _subscriptionMeta));
    } else if (isInserting) {
      context.missing(_subscriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServerGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServerGroup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      subscription: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subscription'])!,
    );
  }

  @override
  $ServerGroupsTable createAlias(String alias) {
    return $ServerGroupsTable(attachedDatabase, alias);
  }
}

class ServerGroup extends DataClass implements Insertable<ServerGroup> {
  final int id;
  final String name;
  final String subscription;
  const ServerGroup(
      {required this.id, required this.name, required this.subscription});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['subscription'] = Variable<String>(subscription);
    return map;
  }

  ServerGroupsCompanion toCompanion(bool nullToAbsent) {
    return ServerGroupsCompanion(
      id: Value(id),
      name: Value(name),
      subscription: Value(subscription),
    );
  }

  factory ServerGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServerGroup(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      subscription: serializer.fromJson<String>(json['subscription']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'subscription': serializer.toJson<String>(subscription),
    };
  }

  ServerGroup copyWith({int? id, String? name, String? subscription}) =>
      ServerGroup(
        id: id ?? this.id,
        name: name ?? this.name,
        subscription: subscription ?? this.subscription,
      );
  @override
  String toString() {
    return (StringBuffer('ServerGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('subscription: $subscription')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, subscription);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.subscription == this.subscription);
}

class ServerGroupsCompanion extends UpdateCompanion<ServerGroup> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> subscription;
  const ServerGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.subscription = const Value.absent(),
  });
  ServerGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String subscription,
  })  : name = Value(name),
        subscription = Value(subscription);
  static Insertable<ServerGroup> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? subscription,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (subscription != null) 'subscription': subscription,
    });
  }

  ServerGroupsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String>? subscription}) {
    return ServerGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      subscription: subscription ?? this.subscription,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (subscription.present) {
      map['subscription'] = Variable<String>(subscription.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServerGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('subscription: $subscription')
          ..write(')'))
        .toString();
  }
}

class $ServersTable extends Servers with TableInfo<$ServersTable, Server> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _protocolMeta =
      const VerificationMeta('protocol');
  @override
  late final GeneratedColumn<String> protocol = GeneratedColumn<String>(
      'protocol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _remarkMeta = const VerificationMeta('remark');
  @override
  late final GeneratedColumn<String> remark = GeneratedColumn<String>(
      'remark', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
      'port', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _uplinkMeta = const VerificationMeta('uplink');
  @override
  late final GeneratedColumn<int> uplink = GeneratedColumn<int>(
      'uplink', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _downlinkMeta =
      const VerificationMeta('downlink');
  @override
  late final GeneratedColumn<int> downlink = GeneratedColumn<int>(
      'downlink', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _routingProviderMeta =
      const VerificationMeta('routingProvider');
  @override
  late final GeneratedColumn<int> routingProvider = GeneratedColumn<int>(
      'routing_provider', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _protocolProviderMeta =
      const VerificationMeta('protocolProvider');
  @override
  late final GeneratedColumn<int> protocolProvider = GeneratedColumn<int>(
      'protocol_provider', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _authPayloadMeta =
      const VerificationMeta('authPayload');
  @override
  late final GeneratedColumn<String> authPayload = GeneratedColumn<String>(
      'auth_payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _alterIdMeta =
      const VerificationMeta('alterId');
  @override
  late final GeneratedColumn<int> alterId = GeneratedColumn<int>(
      'alter_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _encryptionMeta =
      const VerificationMeta('encryption');
  @override
  late final GeneratedColumn<String> encryption = GeneratedColumn<String>(
      'encryption', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _flowMeta = const VerificationMeta('flow');
  @override
  late final GeneratedColumn<String> flow = GeneratedColumn<String>(
      'flow', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _transportMeta =
      const VerificationMeta('transport');
  @override
  late final GeneratedColumn<String> transport = GeneratedColumn<String>(
      'transport', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
      'host', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _grpcModeMeta =
      const VerificationMeta('grpcMode');
  @override
  late final GeneratedColumn<String> grpcMode = GeneratedColumn<String>(
      'grpc_mode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _serviceNameMeta =
      const VerificationMeta('serviceName');
  @override
  late final GeneratedColumn<String> serviceName = GeneratedColumn<String>(
      'service_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tlsMeta = const VerificationMeta('tls');
  @override
  late final GeneratedColumn<String> tls = GeneratedColumn<String>(
      'tls', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _serverNameMeta =
      const VerificationMeta('serverName');
  @override
  late final GeneratedColumn<String> serverName = GeneratedColumn<String>(
      'server_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fingerprintMeta =
      const VerificationMeta('fingerprint');
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
      'fingerprint', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publicKeyMeta =
      const VerificationMeta('publicKey');
  @override
  late final GeneratedColumn<String> publicKey = GeneratedColumn<String>(
      'public_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _shortIdMeta =
      const VerificationMeta('shortId');
  @override
  late final GeneratedColumn<String> shortId = GeneratedColumn<String>(
      'short_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _spiderXMeta =
      const VerificationMeta('spiderX');
  @override
  late final GeneratedColumn<String> spiderX = GeneratedColumn<String>(
      'spider_x', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _allowInsecureMeta =
      const VerificationMeta('allowInsecure');
  @override
  late final GeneratedColumn<bool> allowInsecure = GeneratedColumn<bool>(
      'allow_insecure', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("allow_insecure" IN (0, 1))'));
  static const VerificationMeta _pluginMeta = const VerificationMeta('plugin');
  @override
  late final GeneratedColumn<String> plugin = GeneratedColumn<String>(
      'plugin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pluginOptsMeta =
      const VerificationMeta('pluginOpts');
  @override
  late final GeneratedColumn<String> pluginOpts = GeneratedColumn<String>(
      'plugin_opts', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hysteriaProtocolMeta =
      const VerificationMeta('hysteriaProtocol');
  @override
  late final GeneratedColumn<String> hysteriaProtocol = GeneratedColumn<String>(
      'hysteria_protocol', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _obfsMeta = const VerificationMeta('obfs');
  @override
  late final GeneratedColumn<String> obfs = GeneratedColumn<String>(
      'obfs', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _alpnMeta = const VerificationMeta('alpn');
  @override
  late final GeneratedColumn<String> alpn = GeneratedColumn<String>(
      'alpn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authTypeMeta =
      const VerificationMeta('authType');
  @override
  late final GeneratedColumn<String> authType = GeneratedColumn<String>(
      'auth_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _upMbpsMeta = const VerificationMeta('upMbps');
  @override
  late final GeneratedColumn<int> upMbps = GeneratedColumn<int>(
      'up_mbps', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _downMbpsMeta =
      const VerificationMeta('downMbps');
  @override
  late final GeneratedColumn<int> downMbps = GeneratedColumn<int>(
      'down_mbps', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _recvWindowConnMeta =
      const VerificationMeta('recvWindowConn');
  @override
  late final GeneratedColumn<int> recvWindowConn = GeneratedColumn<int>(
      'recv_window_conn', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _recvWindowMeta =
      const VerificationMeta('recvWindow');
  @override
  late final GeneratedColumn<int> recvWindow = GeneratedColumn<int>(
      'recv_window', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _disableMtuDiscoveryMeta =
      const VerificationMeta('disableMtuDiscovery');
  @override
  late final GeneratedColumn<bool> disableMtuDiscovery = GeneratedColumn<bool>(
      'disable_mtu_discovery', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("disable_mtu_discovery" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        groupId,
        protocol,
        remark,
        address,
        port,
        uplink,
        downlink,
        routingProvider,
        protocolProvider,
        authPayload,
        alterId,
        encryption,
        flow,
        transport,
        host,
        path,
        grpcMode,
        serviceName,
        tls,
        serverName,
        fingerprint,
        publicKey,
        shortId,
        spiderX,
        allowInsecure,
        plugin,
        pluginOpts,
        hysteriaProtocol,
        obfs,
        alpn,
        authType,
        upMbps,
        downMbps,
        recvWindowConn,
        recvWindow,
        disableMtuDiscovery
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servers';
  @override
  VerificationContext validateIntegrity(Insertable<Server> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('protocol')) {
      context.handle(_protocolMeta,
          protocol.isAcceptableOrUnknown(data['protocol']!, _protocolMeta));
    } else if (isInserting) {
      context.missing(_protocolMeta);
    }
    if (data.containsKey('remark')) {
      context.handle(_remarkMeta,
          remark.isAcceptableOrUnknown(data['remark']!, _remarkMeta));
    } else if (isInserting) {
      context.missing(_remarkMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
          _portMeta, port.isAcceptableOrUnknown(data['port']!, _portMeta));
    } else if (isInserting) {
      context.missing(_portMeta);
    }
    if (data.containsKey('uplink')) {
      context.handle(_uplinkMeta,
          uplink.isAcceptableOrUnknown(data['uplink']!, _uplinkMeta));
    }
    if (data.containsKey('downlink')) {
      context.handle(_downlinkMeta,
          downlink.isAcceptableOrUnknown(data['downlink']!, _downlinkMeta));
    }
    if (data.containsKey('routing_provider')) {
      context.handle(
          _routingProviderMeta,
          routingProvider.isAcceptableOrUnknown(
              data['routing_provider']!, _routingProviderMeta));
    }
    if (data.containsKey('protocol_provider')) {
      context.handle(
          _protocolProviderMeta,
          protocolProvider.isAcceptableOrUnknown(
              data['protocol_provider']!, _protocolProviderMeta));
    }
    if (data.containsKey('auth_payload')) {
      context.handle(
          _authPayloadMeta,
          authPayload.isAcceptableOrUnknown(
              data['auth_payload']!, _authPayloadMeta));
    } else if (isInserting) {
      context.missing(_authPayloadMeta);
    }
    if (data.containsKey('alter_id')) {
      context.handle(_alterIdMeta,
          alterId.isAcceptableOrUnknown(data['alter_id']!, _alterIdMeta));
    }
    if (data.containsKey('encryption')) {
      context.handle(
          _encryptionMeta,
          encryption.isAcceptableOrUnknown(
              data['encryption']!, _encryptionMeta));
    }
    if (data.containsKey('flow')) {
      context.handle(
          _flowMeta, flow.isAcceptableOrUnknown(data['flow']!, _flowMeta));
    }
    if (data.containsKey('transport')) {
      context.handle(_transportMeta,
          transport.isAcceptableOrUnknown(data['transport']!, _transportMeta));
    }
    if (data.containsKey('host')) {
      context.handle(
          _hostMeta, host.isAcceptableOrUnknown(data['host']!, _hostMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    }
    if (data.containsKey('grpc_mode')) {
      context.handle(_grpcModeMeta,
          grpcMode.isAcceptableOrUnknown(data['grpc_mode']!, _grpcModeMeta));
    }
    if (data.containsKey('service_name')) {
      context.handle(
          _serviceNameMeta,
          serviceName.isAcceptableOrUnknown(
              data['service_name']!, _serviceNameMeta));
    }
    if (data.containsKey('tls')) {
      context.handle(
          _tlsMeta, tls.isAcceptableOrUnknown(data['tls']!, _tlsMeta));
    }
    if (data.containsKey('server_name')) {
      context.handle(
          _serverNameMeta,
          serverName.isAcceptableOrUnknown(
              data['server_name']!, _serverNameMeta));
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
          _fingerprintMeta,
          fingerprint.isAcceptableOrUnknown(
              data['fingerprint']!, _fingerprintMeta));
    }
    if (data.containsKey('public_key')) {
      context.handle(_publicKeyMeta,
          publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta));
    }
    if (data.containsKey('short_id')) {
      context.handle(_shortIdMeta,
          shortId.isAcceptableOrUnknown(data['short_id']!, _shortIdMeta));
    }
    if (data.containsKey('spider_x')) {
      context.handle(_spiderXMeta,
          spiderX.isAcceptableOrUnknown(data['spider_x']!, _spiderXMeta));
    }
    if (data.containsKey('allow_insecure')) {
      context.handle(
          _allowInsecureMeta,
          allowInsecure.isAcceptableOrUnknown(
              data['allow_insecure']!, _allowInsecureMeta));
    }
    if (data.containsKey('plugin')) {
      context.handle(_pluginMeta,
          plugin.isAcceptableOrUnknown(data['plugin']!, _pluginMeta));
    }
    if (data.containsKey('plugin_opts')) {
      context.handle(
          _pluginOptsMeta,
          pluginOpts.isAcceptableOrUnknown(
              data['plugin_opts']!, _pluginOptsMeta));
    }
    if (data.containsKey('hysteria_protocol')) {
      context.handle(
          _hysteriaProtocolMeta,
          hysteriaProtocol.isAcceptableOrUnknown(
              data['hysteria_protocol']!, _hysteriaProtocolMeta));
    }
    if (data.containsKey('obfs')) {
      context.handle(
          _obfsMeta, obfs.isAcceptableOrUnknown(data['obfs']!, _obfsMeta));
    }
    if (data.containsKey('alpn')) {
      context.handle(
          _alpnMeta, alpn.isAcceptableOrUnknown(data['alpn']!, _alpnMeta));
    }
    if (data.containsKey('auth_type')) {
      context.handle(_authTypeMeta,
          authType.isAcceptableOrUnknown(data['auth_type']!, _authTypeMeta));
    }
    if (data.containsKey('up_mbps')) {
      context.handle(_upMbpsMeta,
          upMbps.isAcceptableOrUnknown(data['up_mbps']!, _upMbpsMeta));
    }
    if (data.containsKey('down_mbps')) {
      context.handle(_downMbpsMeta,
          downMbps.isAcceptableOrUnknown(data['down_mbps']!, _downMbpsMeta));
    }
    if (data.containsKey('recv_window_conn')) {
      context.handle(
          _recvWindowConnMeta,
          recvWindowConn.isAcceptableOrUnknown(
              data['recv_window_conn']!, _recvWindowConnMeta));
    }
    if (data.containsKey('recv_window')) {
      context.handle(
          _recvWindowMeta,
          recvWindow.isAcceptableOrUnknown(
              data['recv_window']!, _recvWindowMeta));
    }
    if (data.containsKey('disable_mtu_discovery')) {
      context.handle(
          _disableMtuDiscoveryMeta,
          disableMtuDiscovery.isAcceptableOrUnknown(
              data['disable_mtu_discovery']!, _disableMtuDiscoveryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Server map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Server(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      protocol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}protocol'])!,
      remark: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remark'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      port: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}port'])!,
      uplink: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}uplink']),
      downlink: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}downlink']),
      routingProvider: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}routing_provider']),
      protocolProvider: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}protocol_provider']),
      authPayload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}auth_payload'])!,
      alterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}alter_id']),
      encryption: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encryption']),
      flow: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flow']),
      transport: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transport']),
      host: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}host']),
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path']),
      grpcMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}grpc_mode']),
      serviceName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}service_name']),
      tls: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tls']),
      serverName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_name']),
      fingerprint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fingerprint']),
      publicKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}public_key']),
      shortId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}short_id']),
      spiderX: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}spider_x']),
      allowInsecure: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}allow_insecure']),
      plugin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plugin']),
      pluginOpts: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plugin_opts']),
      hysteriaProtocol: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}hysteria_protocol']),
      obfs: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}obfs']),
      alpn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alpn']),
      authType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}auth_type']),
      upMbps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}up_mbps']),
      downMbps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}down_mbps']),
      recvWindowConn: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recv_window_conn']),
      recvWindow: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recv_window']),
      disableMtuDiscovery: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}disable_mtu_discovery']),
    );
  }

  @override
  $ServersTable createAlias(String alias) {
    return $ServersTable(attachedDatabase, alias);
  }
}

class Server extends DataClass implements Insertable<Server> {
  final int id;
  final int groupId;
  final String protocol;
  final String remark;
  final String address;
  final int port;
  final int? uplink;
  final int? downlink;
  final int? routingProvider;
  final int? protocolProvider;
  final String authPayload;
  final int? alterId;
  final String? encryption;
  final String? flow;
  final String? transport;
  final String? host;
  final String? path;
  final String? grpcMode;
  final String? serviceName;
  final String? tls;
  final String? serverName;
  final String? fingerprint;
  final String? publicKey;
  final String? shortId;
  final String? spiderX;
  final bool? allowInsecure;
  final String? plugin;
  final String? pluginOpts;
  final String? hysteriaProtocol;
  final String? obfs;
  final String? alpn;
  final String? authType;
  final int? upMbps;
  final int? downMbps;
  final int? recvWindowConn;
  final int? recvWindow;
  final bool? disableMtuDiscovery;
  const Server(
      {required this.id,
      required this.groupId,
      required this.protocol,
      required this.remark,
      required this.address,
      required this.port,
      this.uplink,
      this.downlink,
      this.routingProvider,
      this.protocolProvider,
      required this.authPayload,
      this.alterId,
      this.encryption,
      this.flow,
      this.transport,
      this.host,
      this.path,
      this.grpcMode,
      this.serviceName,
      this.tls,
      this.serverName,
      this.fingerprint,
      this.publicKey,
      this.shortId,
      this.spiderX,
      this.allowInsecure,
      this.plugin,
      this.pluginOpts,
      this.hysteriaProtocol,
      this.obfs,
      this.alpn,
      this.authType,
      this.upMbps,
      this.downMbps,
      this.recvWindowConn,
      this.recvWindow,
      this.disableMtuDiscovery});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['protocol'] = Variable<String>(protocol);
    map['remark'] = Variable<String>(remark);
    map['address'] = Variable<String>(address);
    map['port'] = Variable<int>(port);
    if (!nullToAbsent || uplink != null) {
      map['uplink'] = Variable<int>(uplink);
    }
    if (!nullToAbsent || downlink != null) {
      map['downlink'] = Variable<int>(downlink);
    }
    if (!nullToAbsent || routingProvider != null) {
      map['routing_provider'] = Variable<int>(routingProvider);
    }
    if (!nullToAbsent || protocolProvider != null) {
      map['protocol_provider'] = Variable<int>(protocolProvider);
    }
    map['auth_payload'] = Variable<String>(authPayload);
    if (!nullToAbsent || alterId != null) {
      map['alter_id'] = Variable<int>(alterId);
    }
    if (!nullToAbsent || encryption != null) {
      map['encryption'] = Variable<String>(encryption);
    }
    if (!nullToAbsent || flow != null) {
      map['flow'] = Variable<String>(flow);
    }
    if (!nullToAbsent || transport != null) {
      map['transport'] = Variable<String>(transport);
    }
    if (!nullToAbsent || host != null) {
      map['host'] = Variable<String>(host);
    }
    if (!nullToAbsent || path != null) {
      map['path'] = Variable<String>(path);
    }
    if (!nullToAbsent || grpcMode != null) {
      map['grpc_mode'] = Variable<String>(grpcMode);
    }
    if (!nullToAbsent || serviceName != null) {
      map['service_name'] = Variable<String>(serviceName);
    }
    if (!nullToAbsent || tls != null) {
      map['tls'] = Variable<String>(tls);
    }
    if (!nullToAbsent || serverName != null) {
      map['server_name'] = Variable<String>(serverName);
    }
    if (!nullToAbsent || fingerprint != null) {
      map['fingerprint'] = Variable<String>(fingerprint);
    }
    if (!nullToAbsent || publicKey != null) {
      map['public_key'] = Variable<String>(publicKey);
    }
    if (!nullToAbsent || shortId != null) {
      map['short_id'] = Variable<String>(shortId);
    }
    if (!nullToAbsent || spiderX != null) {
      map['spider_x'] = Variable<String>(spiderX);
    }
    if (!nullToAbsent || allowInsecure != null) {
      map['allow_insecure'] = Variable<bool>(allowInsecure);
    }
    if (!nullToAbsent || plugin != null) {
      map['plugin'] = Variable<String>(plugin);
    }
    if (!nullToAbsent || pluginOpts != null) {
      map['plugin_opts'] = Variable<String>(pluginOpts);
    }
    if (!nullToAbsent || hysteriaProtocol != null) {
      map['hysteria_protocol'] = Variable<String>(hysteriaProtocol);
    }
    if (!nullToAbsent || obfs != null) {
      map['obfs'] = Variable<String>(obfs);
    }
    if (!nullToAbsent || alpn != null) {
      map['alpn'] = Variable<String>(alpn);
    }
    if (!nullToAbsent || authType != null) {
      map['auth_type'] = Variable<String>(authType);
    }
    if (!nullToAbsent || upMbps != null) {
      map['up_mbps'] = Variable<int>(upMbps);
    }
    if (!nullToAbsent || downMbps != null) {
      map['down_mbps'] = Variable<int>(downMbps);
    }
    if (!nullToAbsent || recvWindowConn != null) {
      map['recv_window_conn'] = Variable<int>(recvWindowConn);
    }
    if (!nullToAbsent || recvWindow != null) {
      map['recv_window'] = Variable<int>(recvWindow);
    }
    if (!nullToAbsent || disableMtuDiscovery != null) {
      map['disable_mtu_discovery'] = Variable<bool>(disableMtuDiscovery);
    }
    return map;
  }

  ServersCompanion toCompanion(bool nullToAbsent) {
    return ServersCompanion(
      id: Value(id),
      groupId: Value(groupId),
      protocol: Value(protocol),
      remark: Value(remark),
      address: Value(address),
      port: Value(port),
      uplink:
          uplink == null && nullToAbsent ? const Value.absent() : Value(uplink),
      downlink: downlink == null && nullToAbsent
          ? const Value.absent()
          : Value(downlink),
      routingProvider: routingProvider == null && nullToAbsent
          ? const Value.absent()
          : Value(routingProvider),
      protocolProvider: protocolProvider == null && nullToAbsent
          ? const Value.absent()
          : Value(protocolProvider),
      authPayload: Value(authPayload),
      alterId: alterId == null && nullToAbsent
          ? const Value.absent()
          : Value(alterId),
      encryption: encryption == null && nullToAbsent
          ? const Value.absent()
          : Value(encryption),
      flow: flow == null && nullToAbsent ? const Value.absent() : Value(flow),
      transport: transport == null && nullToAbsent
          ? const Value.absent()
          : Value(transport),
      host: host == null && nullToAbsent ? const Value.absent() : Value(host),
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
      grpcMode: grpcMode == null && nullToAbsent
          ? const Value.absent()
          : Value(grpcMode),
      serviceName: serviceName == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceName),
      tls: tls == null && nullToAbsent ? const Value.absent() : Value(tls),
      serverName: serverName == null && nullToAbsent
          ? const Value.absent()
          : Value(serverName),
      fingerprint: fingerprint == null && nullToAbsent
          ? const Value.absent()
          : Value(fingerprint),
      publicKey: publicKey == null && nullToAbsent
          ? const Value.absent()
          : Value(publicKey),
      shortId: shortId == null && nullToAbsent
          ? const Value.absent()
          : Value(shortId),
      spiderX: spiderX == null && nullToAbsent
          ? const Value.absent()
          : Value(spiderX),
      allowInsecure: allowInsecure == null && nullToAbsent
          ? const Value.absent()
          : Value(allowInsecure),
      plugin:
          plugin == null && nullToAbsent ? const Value.absent() : Value(plugin),
      pluginOpts: pluginOpts == null && nullToAbsent
          ? const Value.absent()
          : Value(pluginOpts),
      hysteriaProtocol: hysteriaProtocol == null && nullToAbsent
          ? const Value.absent()
          : Value(hysteriaProtocol),
      obfs: obfs == null && nullToAbsent ? const Value.absent() : Value(obfs),
      alpn: alpn == null && nullToAbsent ? const Value.absent() : Value(alpn),
      authType: authType == null && nullToAbsent
          ? const Value.absent()
          : Value(authType),
      upMbps:
          upMbps == null && nullToAbsent ? const Value.absent() : Value(upMbps),
      downMbps: downMbps == null && nullToAbsent
          ? const Value.absent()
          : Value(downMbps),
      recvWindowConn: recvWindowConn == null && nullToAbsent
          ? const Value.absent()
          : Value(recvWindowConn),
      recvWindow: recvWindow == null && nullToAbsent
          ? const Value.absent()
          : Value(recvWindow),
      disableMtuDiscovery: disableMtuDiscovery == null && nullToAbsent
          ? const Value.absent()
          : Value(disableMtuDiscovery),
    );
  }

  factory Server.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Server(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      protocol: serializer.fromJson<String>(json['protocol']),
      remark: serializer.fromJson<String>(json['remark']),
      address: serializer.fromJson<String>(json['address']),
      port: serializer.fromJson<int>(json['port']),
      uplink: serializer.fromJson<int?>(json['uplink']),
      downlink: serializer.fromJson<int?>(json['downlink']),
      routingProvider: serializer.fromJson<int?>(json['routingProvider']),
      protocolProvider: serializer.fromJson<int?>(json['protocolProvider']),
      authPayload: serializer.fromJson<String>(json['authPayload']),
      alterId: serializer.fromJson<int?>(json['alterId']),
      encryption: serializer.fromJson<String?>(json['encryption']),
      flow: serializer.fromJson<String?>(json['flow']),
      transport: serializer.fromJson<String?>(json['transport']),
      host: serializer.fromJson<String?>(json['host']),
      path: serializer.fromJson<String?>(json['path']),
      grpcMode: serializer.fromJson<String?>(json['grpcMode']),
      serviceName: serializer.fromJson<String?>(json['serviceName']),
      tls: serializer.fromJson<String?>(json['tls']),
      serverName: serializer.fromJson<String?>(json['serverName']),
      fingerprint: serializer.fromJson<String?>(json['fingerprint']),
      publicKey: serializer.fromJson<String?>(json['publicKey']),
      shortId: serializer.fromJson<String?>(json['shortId']),
      spiderX: serializer.fromJson<String?>(json['spiderX']),
      allowInsecure: serializer.fromJson<bool?>(json['allowInsecure']),
      plugin: serializer.fromJson<String?>(json['plugin']),
      pluginOpts: serializer.fromJson<String?>(json['pluginOpts']),
      hysteriaProtocol: serializer.fromJson<String?>(json['hysteriaProtocol']),
      obfs: serializer.fromJson<String?>(json['obfs']),
      alpn: serializer.fromJson<String?>(json['alpn']),
      authType: serializer.fromJson<String?>(json['authType']),
      upMbps: serializer.fromJson<int?>(json['upMbps']),
      downMbps: serializer.fromJson<int?>(json['downMbps']),
      recvWindowConn: serializer.fromJson<int?>(json['recvWindowConn']),
      recvWindow: serializer.fromJson<int?>(json['recvWindow']),
      disableMtuDiscovery:
          serializer.fromJson<bool?>(json['disableMtuDiscovery']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'protocol': serializer.toJson<String>(protocol),
      'remark': serializer.toJson<String>(remark),
      'address': serializer.toJson<String>(address),
      'port': serializer.toJson<int>(port),
      'uplink': serializer.toJson<int?>(uplink),
      'downlink': serializer.toJson<int?>(downlink),
      'routingProvider': serializer.toJson<int?>(routingProvider),
      'protocolProvider': serializer.toJson<int?>(protocolProvider),
      'authPayload': serializer.toJson<String>(authPayload),
      'alterId': serializer.toJson<int?>(alterId),
      'encryption': serializer.toJson<String?>(encryption),
      'flow': serializer.toJson<String?>(flow),
      'transport': serializer.toJson<String?>(transport),
      'host': serializer.toJson<String?>(host),
      'path': serializer.toJson<String?>(path),
      'grpcMode': serializer.toJson<String?>(grpcMode),
      'serviceName': serializer.toJson<String?>(serviceName),
      'tls': serializer.toJson<String?>(tls),
      'serverName': serializer.toJson<String?>(serverName),
      'fingerprint': serializer.toJson<String?>(fingerprint),
      'publicKey': serializer.toJson<String?>(publicKey),
      'shortId': serializer.toJson<String?>(shortId),
      'spiderX': serializer.toJson<String?>(spiderX),
      'allowInsecure': serializer.toJson<bool?>(allowInsecure),
      'plugin': serializer.toJson<String?>(plugin),
      'pluginOpts': serializer.toJson<String?>(pluginOpts),
      'hysteriaProtocol': serializer.toJson<String?>(hysteriaProtocol),
      'obfs': serializer.toJson<String?>(obfs),
      'alpn': serializer.toJson<String?>(alpn),
      'authType': serializer.toJson<String?>(authType),
      'upMbps': serializer.toJson<int?>(upMbps),
      'downMbps': serializer.toJson<int?>(downMbps),
      'recvWindowConn': serializer.toJson<int?>(recvWindowConn),
      'recvWindow': serializer.toJson<int?>(recvWindow),
      'disableMtuDiscovery': serializer.toJson<bool?>(disableMtuDiscovery),
    };
  }

  Server copyWith(
          {int? id,
          int? groupId,
          String? protocol,
          String? remark,
          String? address,
          int? port,
          Value<int?> uplink = const Value.absent(),
          Value<int?> downlink = const Value.absent(),
          Value<int?> routingProvider = const Value.absent(),
          Value<int?> protocolProvider = const Value.absent(),
          String? authPayload,
          Value<int?> alterId = const Value.absent(),
          Value<String?> encryption = const Value.absent(),
          Value<String?> flow = const Value.absent(),
          Value<String?> transport = const Value.absent(),
          Value<String?> host = const Value.absent(),
          Value<String?> path = const Value.absent(),
          Value<String?> grpcMode = const Value.absent(),
          Value<String?> serviceName = const Value.absent(),
          Value<String?> tls = const Value.absent(),
          Value<String?> serverName = const Value.absent(),
          Value<String?> fingerprint = const Value.absent(),
          Value<String?> publicKey = const Value.absent(),
          Value<String?> shortId = const Value.absent(),
          Value<String?> spiderX = const Value.absent(),
          Value<bool?> allowInsecure = const Value.absent(),
          Value<String?> plugin = const Value.absent(),
          Value<String?> pluginOpts = const Value.absent(),
          Value<String?> hysteriaProtocol = const Value.absent(),
          Value<String?> obfs = const Value.absent(),
          Value<String?> alpn = const Value.absent(),
          Value<String?> authType = const Value.absent(),
          Value<int?> upMbps = const Value.absent(),
          Value<int?> downMbps = const Value.absent(),
          Value<int?> recvWindowConn = const Value.absent(),
          Value<int?> recvWindow = const Value.absent(),
          Value<bool?> disableMtuDiscovery = const Value.absent()}) =>
      Server(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        protocol: protocol ?? this.protocol,
        remark: remark ?? this.remark,
        address: address ?? this.address,
        port: port ?? this.port,
        uplink: uplink.present ? uplink.value : this.uplink,
        downlink: downlink.present ? downlink.value : this.downlink,
        routingProvider: routingProvider.present
            ? routingProvider.value
            : this.routingProvider,
        protocolProvider: protocolProvider.present
            ? protocolProvider.value
            : this.protocolProvider,
        authPayload: authPayload ?? this.authPayload,
        alterId: alterId.present ? alterId.value : this.alterId,
        encryption: encryption.present ? encryption.value : this.encryption,
        flow: flow.present ? flow.value : this.flow,
        transport: transport.present ? transport.value : this.transport,
        host: host.present ? host.value : this.host,
        path: path.present ? path.value : this.path,
        grpcMode: grpcMode.present ? grpcMode.value : this.grpcMode,
        serviceName: serviceName.present ? serviceName.value : this.serviceName,
        tls: tls.present ? tls.value : this.tls,
        serverName: serverName.present ? serverName.value : this.serverName,
        fingerprint: fingerprint.present ? fingerprint.value : this.fingerprint,
        publicKey: publicKey.present ? publicKey.value : this.publicKey,
        shortId: shortId.present ? shortId.value : this.shortId,
        spiderX: spiderX.present ? spiderX.value : this.spiderX,
        allowInsecure:
            allowInsecure.present ? allowInsecure.value : this.allowInsecure,
        plugin: plugin.present ? plugin.value : this.plugin,
        pluginOpts: pluginOpts.present ? pluginOpts.value : this.pluginOpts,
        hysteriaProtocol: hysteriaProtocol.present
            ? hysteriaProtocol.value
            : this.hysteriaProtocol,
        obfs: obfs.present ? obfs.value : this.obfs,
        alpn: alpn.present ? alpn.value : this.alpn,
        authType: authType.present ? authType.value : this.authType,
        upMbps: upMbps.present ? upMbps.value : this.upMbps,
        downMbps: downMbps.present ? downMbps.value : this.downMbps,
        recvWindowConn:
            recvWindowConn.present ? recvWindowConn.value : this.recvWindowConn,
        recvWindow: recvWindow.present ? recvWindow.value : this.recvWindow,
        disableMtuDiscovery: disableMtuDiscovery.present
            ? disableMtuDiscovery.value
            : this.disableMtuDiscovery,
      );
  @override
  String toString() {
    return (StringBuffer('Server(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('protocol: $protocol, ')
          ..write('remark: $remark, ')
          ..write('address: $address, ')
          ..write('port: $port, ')
          ..write('uplink: $uplink, ')
          ..write('downlink: $downlink, ')
          ..write('routingProvider: $routingProvider, ')
          ..write('protocolProvider: $protocolProvider, ')
          ..write('authPayload: $authPayload, ')
          ..write('alterId: $alterId, ')
          ..write('encryption: $encryption, ')
          ..write('flow: $flow, ')
          ..write('transport: $transport, ')
          ..write('host: $host, ')
          ..write('path: $path, ')
          ..write('grpcMode: $grpcMode, ')
          ..write('serviceName: $serviceName, ')
          ..write('tls: $tls, ')
          ..write('serverName: $serverName, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('publicKey: $publicKey, ')
          ..write('shortId: $shortId, ')
          ..write('spiderX: $spiderX, ')
          ..write('allowInsecure: $allowInsecure, ')
          ..write('plugin: $plugin, ')
          ..write('pluginOpts: $pluginOpts, ')
          ..write('hysteriaProtocol: $hysteriaProtocol, ')
          ..write('obfs: $obfs, ')
          ..write('alpn: $alpn, ')
          ..write('authType: $authType, ')
          ..write('upMbps: $upMbps, ')
          ..write('downMbps: $downMbps, ')
          ..write('recvWindowConn: $recvWindowConn, ')
          ..write('recvWindow: $recvWindow, ')
          ..write('disableMtuDiscovery: $disableMtuDiscovery')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        groupId,
        protocol,
        remark,
        address,
        port,
        uplink,
        downlink,
        routingProvider,
        protocolProvider,
        authPayload,
        alterId,
        encryption,
        flow,
        transport,
        host,
        path,
        grpcMode,
        serviceName,
        tls,
        serverName,
        fingerprint,
        publicKey,
        shortId,
        spiderX,
        allowInsecure,
        plugin,
        pluginOpts,
        hysteriaProtocol,
        obfs,
        alpn,
        authType,
        upMbps,
        downMbps,
        recvWindowConn,
        recvWindow,
        disableMtuDiscovery
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Server &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.protocol == this.protocol &&
          other.remark == this.remark &&
          other.address == this.address &&
          other.port == this.port &&
          other.uplink == this.uplink &&
          other.downlink == this.downlink &&
          other.routingProvider == this.routingProvider &&
          other.protocolProvider == this.protocolProvider &&
          other.authPayload == this.authPayload &&
          other.alterId == this.alterId &&
          other.encryption == this.encryption &&
          other.flow == this.flow &&
          other.transport == this.transport &&
          other.host == this.host &&
          other.path == this.path &&
          other.grpcMode == this.grpcMode &&
          other.serviceName == this.serviceName &&
          other.tls == this.tls &&
          other.serverName == this.serverName &&
          other.fingerprint == this.fingerprint &&
          other.publicKey == this.publicKey &&
          other.shortId == this.shortId &&
          other.spiderX == this.spiderX &&
          other.allowInsecure == this.allowInsecure &&
          other.plugin == this.plugin &&
          other.pluginOpts == this.pluginOpts &&
          other.hysteriaProtocol == this.hysteriaProtocol &&
          other.obfs == this.obfs &&
          other.alpn == this.alpn &&
          other.authType == this.authType &&
          other.upMbps == this.upMbps &&
          other.downMbps == this.downMbps &&
          other.recvWindowConn == this.recvWindowConn &&
          other.recvWindow == this.recvWindow &&
          other.disableMtuDiscovery == this.disableMtuDiscovery);
}

class ServersCompanion extends UpdateCompanion<Server> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> protocol;
  final Value<String> remark;
  final Value<String> address;
  final Value<int> port;
  final Value<int?> uplink;
  final Value<int?> downlink;
  final Value<int?> routingProvider;
  final Value<int?> protocolProvider;
  final Value<String> authPayload;
  final Value<int?> alterId;
  final Value<String?> encryption;
  final Value<String?> flow;
  final Value<String?> transport;
  final Value<String?> host;
  final Value<String?> path;
  final Value<String?> grpcMode;
  final Value<String?> serviceName;
  final Value<String?> tls;
  final Value<String?> serverName;
  final Value<String?> fingerprint;
  final Value<String?> publicKey;
  final Value<String?> shortId;
  final Value<String?> spiderX;
  final Value<bool?> allowInsecure;
  final Value<String?> plugin;
  final Value<String?> pluginOpts;
  final Value<String?> hysteriaProtocol;
  final Value<String?> obfs;
  final Value<String?> alpn;
  final Value<String?> authType;
  final Value<int?> upMbps;
  final Value<int?> downMbps;
  final Value<int?> recvWindowConn;
  final Value<int?> recvWindow;
  final Value<bool?> disableMtuDiscovery;
  const ServersCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.protocol = const Value.absent(),
    this.remark = const Value.absent(),
    this.address = const Value.absent(),
    this.port = const Value.absent(),
    this.uplink = const Value.absent(),
    this.downlink = const Value.absent(),
    this.routingProvider = const Value.absent(),
    this.protocolProvider = const Value.absent(),
    this.authPayload = const Value.absent(),
    this.alterId = const Value.absent(),
    this.encryption = const Value.absent(),
    this.flow = const Value.absent(),
    this.transport = const Value.absent(),
    this.host = const Value.absent(),
    this.path = const Value.absent(),
    this.grpcMode = const Value.absent(),
    this.serviceName = const Value.absent(),
    this.tls = const Value.absent(),
    this.serverName = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.shortId = const Value.absent(),
    this.spiderX = const Value.absent(),
    this.allowInsecure = const Value.absent(),
    this.plugin = const Value.absent(),
    this.pluginOpts = const Value.absent(),
    this.hysteriaProtocol = const Value.absent(),
    this.obfs = const Value.absent(),
    this.alpn = const Value.absent(),
    this.authType = const Value.absent(),
    this.upMbps = const Value.absent(),
    this.downMbps = const Value.absent(),
    this.recvWindowConn = const Value.absent(),
    this.recvWindow = const Value.absent(),
    this.disableMtuDiscovery = const Value.absent(),
  });
  ServersCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String protocol,
    required String remark,
    required String address,
    required int port,
    this.uplink = const Value.absent(),
    this.downlink = const Value.absent(),
    this.routingProvider = const Value.absent(),
    this.protocolProvider = const Value.absent(),
    required String authPayload,
    this.alterId = const Value.absent(),
    this.encryption = const Value.absent(),
    this.flow = const Value.absent(),
    this.transport = const Value.absent(),
    this.host = const Value.absent(),
    this.path = const Value.absent(),
    this.grpcMode = const Value.absent(),
    this.serviceName = const Value.absent(),
    this.tls = const Value.absent(),
    this.serverName = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.shortId = const Value.absent(),
    this.spiderX = const Value.absent(),
    this.allowInsecure = const Value.absent(),
    this.plugin = const Value.absent(),
    this.pluginOpts = const Value.absent(),
    this.hysteriaProtocol = const Value.absent(),
    this.obfs = const Value.absent(),
    this.alpn = const Value.absent(),
    this.authType = const Value.absent(),
    this.upMbps = const Value.absent(),
    this.downMbps = const Value.absent(),
    this.recvWindowConn = const Value.absent(),
    this.recvWindow = const Value.absent(),
    this.disableMtuDiscovery = const Value.absent(),
  })  : groupId = Value(groupId),
        protocol = Value(protocol),
        remark = Value(remark),
        address = Value(address),
        port = Value(port),
        authPayload = Value(authPayload);
  static Insertable<Server> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? protocol,
    Expression<String>? remark,
    Expression<String>? address,
    Expression<int>? port,
    Expression<int>? uplink,
    Expression<int>? downlink,
    Expression<int>? routingProvider,
    Expression<int>? protocolProvider,
    Expression<String>? authPayload,
    Expression<int>? alterId,
    Expression<String>? encryption,
    Expression<String>? flow,
    Expression<String>? transport,
    Expression<String>? host,
    Expression<String>? path,
    Expression<String>? grpcMode,
    Expression<String>? serviceName,
    Expression<String>? tls,
    Expression<String>? serverName,
    Expression<String>? fingerprint,
    Expression<String>? publicKey,
    Expression<String>? shortId,
    Expression<String>? spiderX,
    Expression<bool>? allowInsecure,
    Expression<String>? plugin,
    Expression<String>? pluginOpts,
    Expression<String>? hysteriaProtocol,
    Expression<String>? obfs,
    Expression<String>? alpn,
    Expression<String>? authType,
    Expression<int>? upMbps,
    Expression<int>? downMbps,
    Expression<int>? recvWindowConn,
    Expression<int>? recvWindow,
    Expression<bool>? disableMtuDiscovery,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (protocol != null) 'protocol': protocol,
      if (remark != null) 'remark': remark,
      if (address != null) 'address': address,
      if (port != null) 'port': port,
      if (uplink != null) 'uplink': uplink,
      if (downlink != null) 'downlink': downlink,
      if (routingProvider != null) 'routing_provider': routingProvider,
      if (protocolProvider != null) 'protocol_provider': protocolProvider,
      if (authPayload != null) 'auth_payload': authPayload,
      if (alterId != null) 'alter_id': alterId,
      if (encryption != null) 'encryption': encryption,
      if (flow != null) 'flow': flow,
      if (transport != null) 'transport': transport,
      if (host != null) 'host': host,
      if (path != null) 'path': path,
      if (grpcMode != null) 'grpc_mode': grpcMode,
      if (serviceName != null) 'service_name': serviceName,
      if (tls != null) 'tls': tls,
      if (serverName != null) 'server_name': serverName,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (publicKey != null) 'public_key': publicKey,
      if (shortId != null) 'short_id': shortId,
      if (spiderX != null) 'spider_x': spiderX,
      if (allowInsecure != null) 'allow_insecure': allowInsecure,
      if (plugin != null) 'plugin': plugin,
      if (pluginOpts != null) 'plugin_opts': pluginOpts,
      if (hysteriaProtocol != null) 'hysteria_protocol': hysteriaProtocol,
      if (obfs != null) 'obfs': obfs,
      if (alpn != null) 'alpn': alpn,
      if (authType != null) 'auth_type': authType,
      if (upMbps != null) 'up_mbps': upMbps,
      if (downMbps != null) 'down_mbps': downMbps,
      if (recvWindowConn != null) 'recv_window_conn': recvWindowConn,
      if (recvWindow != null) 'recv_window': recvWindow,
      if (disableMtuDiscovery != null)
        'disable_mtu_discovery': disableMtuDiscovery,
    });
  }

  ServersCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<String>? protocol,
      Value<String>? remark,
      Value<String>? address,
      Value<int>? port,
      Value<int?>? uplink,
      Value<int?>? downlink,
      Value<int?>? routingProvider,
      Value<int?>? protocolProvider,
      Value<String>? authPayload,
      Value<int?>? alterId,
      Value<String?>? encryption,
      Value<String?>? flow,
      Value<String?>? transport,
      Value<String?>? host,
      Value<String?>? path,
      Value<String?>? grpcMode,
      Value<String?>? serviceName,
      Value<String?>? tls,
      Value<String?>? serverName,
      Value<String?>? fingerprint,
      Value<String?>? publicKey,
      Value<String?>? shortId,
      Value<String?>? spiderX,
      Value<bool?>? allowInsecure,
      Value<String?>? plugin,
      Value<String?>? pluginOpts,
      Value<String?>? hysteriaProtocol,
      Value<String?>? obfs,
      Value<String?>? alpn,
      Value<String?>? authType,
      Value<int?>? upMbps,
      Value<int?>? downMbps,
      Value<int?>? recvWindowConn,
      Value<int?>? recvWindow,
      Value<bool?>? disableMtuDiscovery}) {
    return ServersCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      protocol: protocol ?? this.protocol,
      remark: remark ?? this.remark,
      address: address ?? this.address,
      port: port ?? this.port,
      uplink: uplink ?? this.uplink,
      downlink: downlink ?? this.downlink,
      routingProvider: routingProvider ?? this.routingProvider,
      protocolProvider: protocolProvider ?? this.protocolProvider,
      authPayload: authPayload ?? this.authPayload,
      alterId: alterId ?? this.alterId,
      encryption: encryption ?? this.encryption,
      flow: flow ?? this.flow,
      transport: transport ?? this.transport,
      host: host ?? this.host,
      path: path ?? this.path,
      grpcMode: grpcMode ?? this.grpcMode,
      serviceName: serviceName ?? this.serviceName,
      tls: tls ?? this.tls,
      serverName: serverName ?? this.serverName,
      fingerprint: fingerprint ?? this.fingerprint,
      publicKey: publicKey ?? this.publicKey,
      shortId: shortId ?? this.shortId,
      spiderX: spiderX ?? this.spiderX,
      allowInsecure: allowInsecure ?? this.allowInsecure,
      plugin: plugin ?? this.plugin,
      pluginOpts: pluginOpts ?? this.pluginOpts,
      hysteriaProtocol: hysteriaProtocol ?? this.hysteriaProtocol,
      obfs: obfs ?? this.obfs,
      alpn: alpn ?? this.alpn,
      authType: authType ?? this.authType,
      upMbps: upMbps ?? this.upMbps,
      downMbps: downMbps ?? this.downMbps,
      recvWindowConn: recvWindowConn ?? this.recvWindowConn,
      recvWindow: recvWindow ?? this.recvWindow,
      disableMtuDiscovery: disableMtuDiscovery ?? this.disableMtuDiscovery,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (protocol.present) {
      map['protocol'] = Variable<String>(protocol.value);
    }
    if (remark.present) {
      map['remark'] = Variable<String>(remark.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (uplink.present) {
      map['uplink'] = Variable<int>(uplink.value);
    }
    if (downlink.present) {
      map['downlink'] = Variable<int>(downlink.value);
    }
    if (routingProvider.present) {
      map['routing_provider'] = Variable<int>(routingProvider.value);
    }
    if (protocolProvider.present) {
      map['protocol_provider'] = Variable<int>(protocolProvider.value);
    }
    if (authPayload.present) {
      map['auth_payload'] = Variable<String>(authPayload.value);
    }
    if (alterId.present) {
      map['alter_id'] = Variable<int>(alterId.value);
    }
    if (encryption.present) {
      map['encryption'] = Variable<String>(encryption.value);
    }
    if (flow.present) {
      map['flow'] = Variable<String>(flow.value);
    }
    if (transport.present) {
      map['transport'] = Variable<String>(transport.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (grpcMode.present) {
      map['grpc_mode'] = Variable<String>(grpcMode.value);
    }
    if (serviceName.present) {
      map['service_name'] = Variable<String>(serviceName.value);
    }
    if (tls.present) {
      map['tls'] = Variable<String>(tls.value);
    }
    if (serverName.present) {
      map['server_name'] = Variable<String>(serverName.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<String>(publicKey.value);
    }
    if (shortId.present) {
      map['short_id'] = Variable<String>(shortId.value);
    }
    if (spiderX.present) {
      map['spider_x'] = Variable<String>(spiderX.value);
    }
    if (allowInsecure.present) {
      map['allow_insecure'] = Variable<bool>(allowInsecure.value);
    }
    if (plugin.present) {
      map['plugin'] = Variable<String>(plugin.value);
    }
    if (pluginOpts.present) {
      map['plugin_opts'] = Variable<String>(pluginOpts.value);
    }
    if (hysteriaProtocol.present) {
      map['hysteria_protocol'] = Variable<String>(hysteriaProtocol.value);
    }
    if (obfs.present) {
      map['obfs'] = Variable<String>(obfs.value);
    }
    if (alpn.present) {
      map['alpn'] = Variable<String>(alpn.value);
    }
    if (authType.present) {
      map['auth_type'] = Variable<String>(authType.value);
    }
    if (upMbps.present) {
      map['up_mbps'] = Variable<int>(upMbps.value);
    }
    if (downMbps.present) {
      map['down_mbps'] = Variable<int>(downMbps.value);
    }
    if (recvWindowConn.present) {
      map['recv_window_conn'] = Variable<int>(recvWindowConn.value);
    }
    if (recvWindow.present) {
      map['recv_window'] = Variable<int>(recvWindow.value);
    }
    if (disableMtuDiscovery.present) {
      map['disable_mtu_discovery'] = Variable<bool>(disableMtuDiscovery.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServersCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('protocol: $protocol, ')
          ..write('remark: $remark, ')
          ..write('address: $address, ')
          ..write('port: $port, ')
          ..write('uplink: $uplink, ')
          ..write('downlink: $downlink, ')
          ..write('routingProvider: $routingProvider, ')
          ..write('protocolProvider: $protocolProvider, ')
          ..write('authPayload: $authPayload, ')
          ..write('alterId: $alterId, ')
          ..write('encryption: $encryption, ')
          ..write('flow: $flow, ')
          ..write('transport: $transport, ')
          ..write('host: $host, ')
          ..write('path: $path, ')
          ..write('grpcMode: $grpcMode, ')
          ..write('serviceName: $serviceName, ')
          ..write('tls: $tls, ')
          ..write('serverName: $serverName, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('publicKey: $publicKey, ')
          ..write('shortId: $shortId, ')
          ..write('spiderX: $spiderX, ')
          ..write('allowInsecure: $allowInsecure, ')
          ..write('plugin: $plugin, ')
          ..write('pluginOpts: $pluginOpts, ')
          ..write('hysteriaProtocol: $hysteriaProtocol, ')
          ..write('obfs: $obfs, ')
          ..write('alpn: $alpn, ')
          ..write('authType: $authType, ')
          ..write('upMbps: $upMbps, ')
          ..write('downMbps: $downMbps, ')
          ..write('recvWindowConn: $recvWindowConn, ')
          ..write('recvWindow: $recvWindow, ')
          ..write('disableMtuDiscovery: $disableMtuDiscovery')
          ..write(')'))
        .toString();
  }
}

class $RuleGroupsTable extends RuleGroups
    with TableInfo<$RuleGroupsTable, RuleGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RuleGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rule_groups';
  @override
  VerificationContext validateIntegrity(Insertable<RuleGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RuleGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RuleGroup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $RuleGroupsTable createAlias(String alias) {
    return $RuleGroupsTable(attachedDatabase, alias);
  }
}

class RuleGroup extends DataClass implements Insertable<RuleGroup> {
  final int id;
  final String name;
  const RuleGroup({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  RuleGroupsCompanion toCompanion(bool nullToAbsent) {
    return RuleGroupsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory RuleGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RuleGroup(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  RuleGroup copyWith({int? id, String? name}) => RuleGroup(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('RuleGroup(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RuleGroup && other.id == this.id && other.name == this.name);
}

class RuleGroupsCompanion extends UpdateCompanion<RuleGroup> {
  final Value<int> id;
  final Value<String> name;
  const RuleGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  RuleGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<RuleGroup> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  RuleGroupsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return RuleGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RuleGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $RulesTable extends Rules with TableInfo<$RulesTable, Rule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'));
  static const VerificationMeta _outboundTagMeta =
      const VerificationMeta('outboundTag');
  @override
  late final GeneratedColumn<int> outboundTag = GeneratedColumn<int>(
      'outbound_tag', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _domainMeta = const VerificationMeta('domain');
  @override
  late final GeneratedColumn<String> domain = GeneratedColumn<String>(
      'domain', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ipMeta = const VerificationMeta('ip');
  @override
  late final GeneratedColumn<String> ip = GeneratedColumn<String>(
      'ip', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<String> port = GeneratedColumn<String>(
      'port', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _processNameMeta =
      const VerificationMeta('processName');
  @override
  late final GeneratedColumn<String> processName = GeneratedColumn<String>(
      'process_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, groupId, name, enabled, outboundTag, domain, ip, port, processName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rules';
  @override
  VerificationContext validateIntegrity(Insertable<Rule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('outbound_tag')) {
      context.handle(
          _outboundTagMeta,
          outboundTag.isAcceptableOrUnknown(
              data['outbound_tag']!, _outboundTagMeta));
    } else if (isInserting) {
      context.missing(_outboundTagMeta);
    }
    if (data.containsKey('domain')) {
      context.handle(_domainMeta,
          domain.isAcceptableOrUnknown(data['domain']!, _domainMeta));
    }
    if (data.containsKey('ip')) {
      context.handle(_ipMeta, ip.isAcceptableOrUnknown(data['ip']!, _ipMeta));
    }
    if (data.containsKey('port')) {
      context.handle(
          _portMeta, port.isAcceptableOrUnknown(data['port']!, _portMeta));
    }
    if (data.containsKey('process_name')) {
      context.handle(
          _processNameMeta,
          processName.isAcceptableOrUnknown(
              data['process_name']!, _processNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      outboundTag: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}outbound_tag'])!,
      domain: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}domain']),
      ip: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ip']),
      port: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}port']),
      processName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}process_name']),
    );
  }

  @override
  $RulesTable createAlias(String alias) {
    return $RulesTable(attachedDatabase, alias);
  }
}

class Rule extends DataClass implements Insertable<Rule> {
  final int id;
  final int groupId;
  final String name;
  final bool enabled;
  final int outboundTag;
  final String? domain;
  final String? ip;
  final String? port;
  final String? processName;
  const Rule(
      {required this.id,
      required this.groupId,
      required this.name,
      required this.enabled,
      required this.outboundTag,
      this.domain,
      this.ip,
      this.port,
      this.processName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['name'] = Variable<String>(name);
    map['enabled'] = Variable<bool>(enabled);
    map['outbound_tag'] = Variable<int>(outboundTag);
    if (!nullToAbsent || domain != null) {
      map['domain'] = Variable<String>(domain);
    }
    if (!nullToAbsent || ip != null) {
      map['ip'] = Variable<String>(ip);
    }
    if (!nullToAbsent || port != null) {
      map['port'] = Variable<String>(port);
    }
    if (!nullToAbsent || processName != null) {
      map['process_name'] = Variable<String>(processName);
    }
    return map;
  }

  RulesCompanion toCompanion(bool nullToAbsent) {
    return RulesCompanion(
      id: Value(id),
      groupId: Value(groupId),
      name: Value(name),
      enabled: Value(enabled),
      outboundTag: Value(outboundTag),
      domain:
          domain == null && nullToAbsent ? const Value.absent() : Value(domain),
      ip: ip == null && nullToAbsent ? const Value.absent() : Value(ip),
      port: port == null && nullToAbsent ? const Value.absent() : Value(port),
      processName: processName == null && nullToAbsent
          ? const Value.absent()
          : Value(processName),
    );
  }

  factory Rule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rule(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      name: serializer.fromJson<String>(json['name']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      outboundTag: serializer.fromJson<int>(json['outboundTag']),
      domain: serializer.fromJson<String?>(json['domain']),
      ip: serializer.fromJson<String?>(json['ip']),
      port: serializer.fromJson<String?>(json['port']),
      processName: serializer.fromJson<String?>(json['processName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'name': serializer.toJson<String>(name),
      'enabled': serializer.toJson<bool>(enabled),
      'outboundTag': serializer.toJson<int>(outboundTag),
      'domain': serializer.toJson<String?>(domain),
      'ip': serializer.toJson<String?>(ip),
      'port': serializer.toJson<String?>(port),
      'processName': serializer.toJson<String?>(processName),
    };
  }

  Rule copyWith(
          {int? id,
          int? groupId,
          String? name,
          bool? enabled,
          int? outboundTag,
          Value<String?> domain = const Value.absent(),
          Value<String?> ip = const Value.absent(),
          Value<String?> port = const Value.absent(),
          Value<String?> processName = const Value.absent()}) =>
      Rule(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        name: name ?? this.name,
        enabled: enabled ?? this.enabled,
        outboundTag: outboundTag ?? this.outboundTag,
        domain: domain.present ? domain.value : this.domain,
        ip: ip.present ? ip.value : this.ip,
        port: port.present ? port.value : this.port,
        processName: processName.present ? processName.value : this.processName,
      );
  @override
  String toString() {
    return (StringBuffer('Rule(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('enabled: $enabled, ')
          ..write('outboundTag: $outboundTag, ')
          ..write('domain: $domain, ')
          ..write('ip: $ip, ')
          ..write('port: $port, ')
          ..write('processName: $processName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, groupId, name, enabled, outboundTag, domain, ip, port, processName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rule &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.name == this.name &&
          other.enabled == this.enabled &&
          other.outboundTag == this.outboundTag &&
          other.domain == this.domain &&
          other.ip == this.ip &&
          other.port == this.port &&
          other.processName == this.processName);
}

class RulesCompanion extends UpdateCompanion<Rule> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> name;
  final Value<bool> enabled;
  final Value<int> outboundTag;
  final Value<String?> domain;
  final Value<String?> ip;
  final Value<String?> port;
  final Value<String?> processName;
  const RulesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.enabled = const Value.absent(),
    this.outboundTag = const Value.absent(),
    this.domain = const Value.absent(),
    this.ip = const Value.absent(),
    this.port = const Value.absent(),
    this.processName = const Value.absent(),
  });
  RulesCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String name,
    required bool enabled,
    required int outboundTag,
    this.domain = const Value.absent(),
    this.ip = const Value.absent(),
    this.port = const Value.absent(),
    this.processName = const Value.absent(),
  })  : groupId = Value(groupId),
        name = Value(name),
        enabled = Value(enabled),
        outboundTag = Value(outboundTag);
  static Insertable<Rule> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? name,
    Expression<bool>? enabled,
    Expression<int>? outboundTag,
    Expression<String>? domain,
    Expression<String>? ip,
    Expression<String>? port,
    Expression<String>? processName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (enabled != null) 'enabled': enabled,
      if (outboundTag != null) 'outbound_tag': outboundTag,
      if (domain != null) 'domain': domain,
      if (ip != null) 'ip': ip,
      if (port != null) 'port': port,
      if (processName != null) 'process_name': processName,
    });
  }

  RulesCompanion copyWith(
      {Value<int>? id,
      Value<int>? groupId,
      Value<String>? name,
      Value<bool>? enabled,
      Value<int>? outboundTag,
      Value<String?>? domain,
      Value<String?>? ip,
      Value<String?>? port,
      Value<String?>? processName}) {
    return RulesCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      enabled: enabled ?? this.enabled,
      outboundTag: outboundTag ?? this.outboundTag,
      domain: domain ?? this.domain,
      ip: ip ?? this.ip,
      port: port ?? this.port,
      processName: processName ?? this.processName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (outboundTag.present) {
      map['outbound_tag'] = Variable<int>(outboundTag.value);
    }
    if (domain.present) {
      map['domain'] = Variable<String>(domain.value);
    }
    if (ip.present) {
      map['ip'] = Variable<String>(ip.value);
    }
    if (port.present) {
      map['port'] = Variable<String>(port.value);
    }
    if (processName.present) {
      map['process_name'] = Variable<String>(processName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RulesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('enabled: $enabled, ')
          ..write('outboundTag: $outboundTag, ')
          ..write('domain: $domain, ')
          ..write('ip: $ip, ')
          ..write('port: $port, ')
          ..write('processName: $processName')
          ..write(')'))
        .toString();
  }
}

class $GroupsOrderTable extends GroupsOrder
    with TableInfo<$GroupsOrderTable, GroupsOrderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsOrderTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups_order';
  @override
  VerificationContext validateIntegrity(Insertable<GroupsOrderData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupsOrderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupsOrderData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
    );
  }

  @override
  $GroupsOrderTable createAlias(String alias) {
    return $GroupsOrderTable(attachedDatabase, alias);
  }
}

class GroupsOrderData extends DataClass implements Insertable<GroupsOrderData> {
  final int id;
  final String data;
  const GroupsOrderData({required this.id, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['data'] = Variable<String>(data);
    return map;
  }

  GroupsOrderCompanion toCompanion(bool nullToAbsent) {
    return GroupsOrderCompanion(
      id: Value(id),
      data: Value(data),
    );
  }

  factory GroupsOrderData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupsOrderData(
      id: serializer.fromJson<int>(json['id']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'data': serializer.toJson<String>(data),
    };
  }

  GroupsOrderData copyWith({int? id, String? data}) => GroupsOrderData(
        id: id ?? this.id,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('GroupsOrderData(')
          ..write('id: $id, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupsOrderData &&
          other.id == this.id &&
          other.data == this.data);
}

class GroupsOrderCompanion extends UpdateCompanion<GroupsOrderData> {
  final Value<int> id;
  final Value<String> data;
  const GroupsOrderCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
  });
  GroupsOrderCompanion.insert({
    this.id = const Value.absent(),
    required String data,
  }) : data = Value(data);
  static Insertable<GroupsOrderData> custom({
    Expression<int>? id,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (data != null) 'data': data,
    });
  }

  GroupsOrderCompanion copyWith({Value<int>? id, Value<String>? data}) {
    return GroupsOrderCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsOrderCompanion(')
          ..write('id: $id, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $ServersOrderTable extends ServersOrder
    with TableInfo<$ServersOrderTable, ServersOrderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServersOrderTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, groupId, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servers_order';
  @override
  VerificationContext validateIntegrity(Insertable<ServersOrderData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServersOrderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServersOrderData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
    );
  }

  @override
  $ServersOrderTable createAlias(String alias) {
    return $ServersOrderTable(attachedDatabase, alias);
  }
}

class ServersOrderData extends DataClass
    implements Insertable<ServersOrderData> {
  final int id;
  final int groupId;
  final String data;
  const ServersOrderData(
      {required this.id, required this.groupId, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['data'] = Variable<String>(data);
    return map;
  }

  ServersOrderCompanion toCompanion(bool nullToAbsent) {
    return ServersOrderCompanion(
      id: Value(id),
      groupId: Value(groupId),
      data: Value(data),
    );
  }

  factory ServersOrderData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServersOrderData(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'data': serializer.toJson<String>(data),
    };
  }

  ServersOrderData copyWith({int? id, int? groupId, String? data}) =>
      ServersOrderData(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('ServersOrderData(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServersOrderData &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.data == this.data);
}

class ServersOrderCompanion extends UpdateCompanion<ServersOrderData> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> data;
  const ServersOrderCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.data = const Value.absent(),
  });
  ServersOrderCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String data,
  })  : groupId = Value(groupId),
        data = Value(data);
  static Insertable<ServersOrderData> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (data != null) 'data': data,
    });
  }

  ServersOrderCompanion copyWith(
      {Value<int>? id, Value<int>? groupId, Value<String>? data}) {
    return ServersOrderCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServersOrderCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $RulesOrderTable extends RulesOrder
    with TableInfo<$RulesOrderTable, RulesOrderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RulesOrderTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, groupId, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rules_order';
  @override
  VerificationContext validateIntegrity(Insertable<RulesOrderData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RulesOrderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RulesOrderData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
    );
  }

  @override
  $RulesOrderTable createAlias(String alias) {
    return $RulesOrderTable(attachedDatabase, alias);
  }
}

class RulesOrderData extends DataClass implements Insertable<RulesOrderData> {
  final int id;
  final int groupId;
  final String data;
  const RulesOrderData(
      {required this.id, required this.groupId, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['data'] = Variable<String>(data);
    return map;
  }

  RulesOrderCompanion toCompanion(bool nullToAbsent) {
    return RulesOrderCompanion(
      id: Value(id),
      groupId: Value(groupId),
      data: Value(data),
    );
  }

  factory RulesOrderData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RulesOrderData(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'data': serializer.toJson<String>(data),
    };
  }

  RulesOrderData copyWith({int? id, int? groupId, String? data}) =>
      RulesOrderData(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('RulesOrderData(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RulesOrderData &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.data == this.data);
}

class RulesOrderCompanion extends UpdateCompanion<RulesOrderData> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> data;
  const RulesOrderCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.data = const Value.absent(),
  });
  RulesOrderCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String data,
  })  : groupId = Value(groupId),
        data = Value(data);
  static Insertable<RulesOrderData> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (data != null) 'data': data,
    });
  }

  RulesOrderCompanion copyWith(
      {Value<int>? id, Value<int>? groupId, Value<String>? data}) {
    return RulesOrderCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RulesOrderCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  late final $ConfigTable config = $ConfigTable(this);
  late final $ServerGroupsTable serverGroups = $ServerGroupsTable(this);
  late final $ServersTable servers = $ServersTable(this);
  late final $RuleGroupsTable ruleGroups = $RuleGroupsTable(this);
  late final $RulesTable rules = $RulesTable(this);
  late final $GroupsOrderTable groupsOrder = $GroupsOrderTable(this);
  late final $ServersOrderTable serversOrder = $ServersOrderTable(this);
  late final $RulesOrderTable rulesOrder = $RulesOrderTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        config,
        serverGroups,
        servers,
        ruleGroups,
        rules,
        groupsOrder,
        serversOrder,
        rulesOrder
      ];
}
