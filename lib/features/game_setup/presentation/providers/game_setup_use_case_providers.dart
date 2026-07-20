import 'dart:ui';

import 'package:companion_for_cacao/features/game_setup/domain/content/preparation_l10n.dart';
import 'package:companion_for_cacao/features/game_setup/domain/use_cases/prepare_game_use_case.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_setup_use_case_providers.g.dart';

/// Localized preparation content for the active system locale (ca/es/en,
/// falling back to English). Resolved once per session: a system locale
/// change mid-game keeps the generated steps until the next pipeline run
/// (documented limitation, docs/spec-fase-i18n.md §3).
@Riverpod(keepAlive: true)
PreparationL10n preparationL10n(Ref ref) {
  final locale = basicLocaleListResolution(
    PlatformDispatcher.instance.locales,
    AppLocalizations.supportedLocales,
  );
  return PreparationL10n.forLocale(locale);
}

// keepAlive: read from the keepAlive gameSetupProvider — a keepAlive
// provider must not depend on an autoDispose one (riverpod_lint:
// only_use_keep_alive_inside_keep_alive).
@Riverpod(keepAlive: true)
PrepareGameUseCase prepareGameUseCase(Ref ref) {
  return PrepareGameUseCase(l10n: ref.watch(preparationL10nProvider));
}
