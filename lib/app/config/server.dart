import 'package:freezed_annotation/freezed_annotation.dart';

part 'server.freezed.dart';

part 'server.g.dart';

@freezed
class ServerConfig with _$ServerConfig {
  const factory ServerConfig({
    @Default(1) int selectedServerGroupId,
    @Default(0) int selectedServerId,
    @Default(0) int updatedSubscriptionTime,
  }) = _ServerConfig;

  factory ServerConfig.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigFromJson(json);
}
