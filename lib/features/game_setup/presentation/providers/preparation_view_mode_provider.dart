import 'package:companion_for_cacao/config/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preparation_view_mode_provider.g.dart';

/// Whether the preparation opens as a guided pager (true) or as the
/// checklist (false). Persisted per device; the list is the default
/// (spec-fase-ux2 §4).
@Riverpod(keepAlive: true)
class PreparationViewMode extends _$PreparationViewMode {
  @override
  Future<bool> build() =>
      ref.watch(settingsRepositoryProvider).prefersGuidedPreparation();

  Future<void> setGuided({required bool value}) async {
    state = AsyncData(value);
    await ref
        .read(settingsRepositoryProvider)
        .setPrefersGuidedPreparation(value: value);
  }
}
