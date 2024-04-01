import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sphia/util/traffic/traffic.dart';

part 'traffic.freezed.dart';

@freezed
class TrafficState with _$TrafficState {
  const factory TrafficState({
    Traffic? traffic,
  }) = _TrafficState;
}
