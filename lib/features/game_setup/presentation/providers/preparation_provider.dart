import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preparation_provider.g.dart';

@riverpod
class PreparationCompletion extends _$PreparationCompletion {
  @override
  Map<String, bool> build() {
    return {};
  }

  void toggleCompletion(String id) {
    state = {...state, id: !(state[id] ?? false)};
  }

  void setCompletion(String id, bool value) {
    state = {...state, id: value};
  }
}
