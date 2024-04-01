import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/database/database.dart';
import 'package:sphia/core/rule/rule_model.dart';
import 'package:sphia/server/server_model.dart';
import 'package:sphia/server/server_model_lite.dart';

part 'data.g.dart';

@riverpod
List<ServerGroup> serverGroups(Ref ref) => throw UnimplementedError();

@riverpod
List<ServerModel> servers(Ref ref) => throw UnimplementedError();

@riverpod
List<ServerModelLite> serversLite(Ref ref) => throw UnimplementedError();

@riverpod
List<RuleGroup> ruleGroups(Ref ref) => throw UnimplementedError();

@riverpod
List<RuleModel> rules(Ref ref) => throw UnimplementedError();
