import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sphia/app/config/rule.dart';
import 'package:sphia/app/config/server.dart';
import 'package:sphia/app/config/sphia.dart';
import 'package:sphia/app/config/version.dart';

part 'config.g.dart';

@riverpod
SphiaConfig sphiaConfig(Ref ref) => throw UnimplementedError();

@riverpod
ServerConfig serverConfig(Ref ref) => throw UnimplementedError();

@riverpod
RuleConfig ruleConfig(Ref ref) => throw UnimplementedError();

@riverpod
VersionConfig versionConfig(Ref ref) => throw UnimplementedError();
