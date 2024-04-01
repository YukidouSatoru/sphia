import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'visible.g.dart';

@Riverpod(keepAlive: true)
class VisibleNotifier extends _$VisibleNotifier {
  @override
  bool build() => true;

  void set(bool visible) {
    state = visible;
  }
}
