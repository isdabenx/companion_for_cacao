import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preparation_provider.g.dart';

@riverpod
class PreparationCompletion extends _$PreparationCompletion {
  @override
  Map<int, bool> build() {
    return {};
  }

  void toggleCompletion(int index, bool currentValue) {
    state = {...state, index: !currentValue};
  }

  void setCompletion(int index, bool value) {
    state = {...state, index: value};
  }
}
