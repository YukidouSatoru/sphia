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
  String get aliasedName => _alias ?? 'config';
  @override
  String get actualTableName => 'config';
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
  static const VerificationMeta _subscribeMeta =
      const VerificationMeta('subscribe');
  @override
  late final GeneratedColumn<String> subscribe = GeneratedColumn<String>(
      'subscribe', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, subscribe];
  @override
  String get aliasedName => _alias ?? 'server_groups';
  @override
  String get actualTableName => 'server_groups';
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
    if (data.containsKey('subscribe')) {
      context.handle(_subscribeMeta,
          subscribe.isAcceptableOrUnknown(data['subscribe']!, _subscribeMeta));
    } else if (isInserting) {
      context.missing(_subscribeMeta);
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
      subscribe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subscribe'])!,
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
  final String subscribe;
  const ServerGroup(
      {required this.id, required this.name, required this.subscribe});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['subscribe'] = Variable<String>(subscribe);
    return map;
  }

  ServerGroupsCompanion toCompanion(bool nullToAbsent) {
    return ServerGroupsCompanion(
      id: Value(id),
      name: Value(name),
      subscribe: Value(subscribe),
    );
  }

  factory ServerGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServerGroup(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      subscribe: serializer.fromJson<String>(json['subscribe']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'subscribe': serializer.toJson<String>(subscribe),
    };
  }

  ServerGroup copyWith({int? id, String? name, String? subscribe}) =>
      ServerGroup(
        id: id ?? this.id,
        name: name ?? this.name,
        subscribe: subscribe ?? this.subscribe,
      );
  @override
  String toString() {
    return (StringBuffer('ServerGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('subscribe: $subscribe')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, subscribe);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.subscribe == this.subscribe);
}

class ServerGroupsCompanion extends UpdateCompanion<ServerGroup> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> subscribe;
  const ServerGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.subscribe = const Value.absent(),
  });
  ServerGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String subscribe,
  })  : name = Value(name),
        subscribe = Value(subscribe);
  static Insertable<ServerGroup> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? subscribe,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (subscribe != null) 'subscribe': subscribe,
    });
  }

  ServerGroupsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String>? subscribe}) {
    return ServerGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      subscribe: subscribe ?? this.subscribe,
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
    if (subscribe.present) {
      map['subscribe'] = Variable<String>(subscribe.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServerGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('subscribe: $subscribe')
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
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, groupId, data];
  @override
  String get aliasedName => _alias ?? 'servers';
  @override
  String get actualTableName => 'servers';
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
  Server map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Server(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
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
  final String data;
  const Server({required this.id, required this.groupId, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['data'] = Variable<String>(data);
    return map;
  }

  ServersCompanion toCompanion(bool nullToAbsent) {
    return ServersCompanion(
      id: Value(id),
      groupId: Value(groupId),
      data: Value(data),
    );
  }

  factory Server.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Server(
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

  Server copyWith({int? id, int? groupId, String? data}) => Server(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('Server(')
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
      (other is Server &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.data == this.data);
}

class ServersCompanion extends UpdateCompanion<Server> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> data;
  const ServersCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.data = const Value.absent(),
  });
  ServersCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String data,
  })  : groupId = Value(groupId),
        data = Value(data);
  static Insertable<Server> custom({
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

  ServersCompanion copyWith(
      {Value<int>? id, Value<int>? groupId, Value<String>? data}) {
    return ServersCompanion(
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
    return (StringBuffer('ServersCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('data: $data')
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
  String get aliasedName => _alias ?? 'rule_groups';
  @override
  String get actualTableName => 'rule_groups';
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
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, groupId, data];
  @override
  String get aliasedName => _alias ?? 'rules';
  @override
  String get actualTableName => 'rules';
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
  Rule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
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
  final String data;
  const Rule({required this.id, required this.groupId, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['data'] = Variable<String>(data);
    return map;
  }

  RulesCompanion toCompanion(bool nullToAbsent) {
    return RulesCompanion(
      id: Value(id),
      groupId: Value(groupId),
      data: Value(data),
    );
  }

  factory Rule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rule(
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

  Rule copyWith({int? id, int? groupId, String? data}) => Rule(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('Rule(')
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
      (other is Rule &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.data == this.data);
}

class RulesCompanion extends UpdateCompanion<Rule> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<String> data;
  const RulesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.data = const Value.absent(),
  });
  RulesCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required String data,
  })  : groupId = Value(groupId),
        data = Value(data);
  static Insertable<Rule> custom({
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

  RulesCompanion copyWith(
      {Value<int>? id, Value<int>? groupId, Value<String>? data}) {
    return RulesCompanion(
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
    return (StringBuffer('RulesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('data: $data')
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
  String get aliasedName => _alias ?? 'groups_order';
  @override
  String get actualTableName => 'groups_order';
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
  String get aliasedName => _alias ?? 'servers_order';
  @override
  String get actualTableName => 'servers_order';
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
  String get aliasedName => _alias ?? 'rules_order';
  @override
  String get actualTableName => 'rules_order';
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
