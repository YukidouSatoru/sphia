import 'package:json_annotation/json_annotation.dart';

part 'server.g.dart';

@JsonSerializable(includeIfNull: false)
class ServerConfig {
  int selectedServerGroupId;
  int selectedServerId;
  int updatedSubscriptionTime;

  ServerConfig({
    required this.selectedServerGroupId,
    required this.selectedServerId,
    required this.updatedSubscriptionTime,
  });

  factory ServerConfig.defaults() {
    return ServerConfig(
      selectedServerGroupId: 1,
      selectedServerId: 0,
      updatedSubscriptionTime: 0,
    );
  }

  factory ServerConfig.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ServerConfigToJson(this);
}
