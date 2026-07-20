import 'dart:ui';

import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_localizations_provider.g.dart';

/// [AppLocalizations] for the active system locale (ca/es/en, falling back
/// to English), for providers that need localized strings without a
/// BuildContext (e.g. matching the tile search against localized names).
/// Resolved once per session, like `preparationL10nProvider` (documented
/// limitation, docs/spec-fase-i18n.md §3).
@Riverpod(keepAlive: true)
AppLocalizations appLocalizations(Ref ref) {
  final locale = basicLocaleListResolution(
    PlatformDispatcher.instance.locales,
    AppLocalizations.supportedLocales,
  );
  return lookupAppLocalizations(locale);
}
