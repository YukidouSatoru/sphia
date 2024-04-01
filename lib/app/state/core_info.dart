import 'package:freezed_annotation/freezed_annotation.dart';

part 'core_info.freezed.dart';

@freezed
class CoreInfo with _$CoreInfo {
  const factory CoreInfo({
    required String coreName,
    required String repoUrl,
    String? latestVersion,
  }) = _CoreInfo;
}
