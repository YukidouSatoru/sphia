import 'package:drift/drift.dart';

class Config extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get config => text()();
}

class ServerGroups extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get subscribe => text()();
}

class Servers extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get groupId => integer()();

  TextColumn get data => text()();
}

class RuleGroups extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}

class Rules extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get groupId => integer()();

  TextColumn get data => text()();
}

class GroupsOrder extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get data => text()();
}

class ServersOrder extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get groupId => integer()();

  TextColumn get data => text()();
}

class RulesOrder extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get groupId => integer()();

  TextColumn get data => text()();
}
