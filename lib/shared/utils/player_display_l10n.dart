import 'package:companion_for_cacao/core/utils/string_extensions.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';

/// Localized name for a raw player color string ('red', 'white'...).
/// Falls back to the raw value for unknown colors.
String localizedColorName(AppLocalizations l10n, String color) =>
    switch (color) {
      'white' => l10n.colorWhite,
      'red' => l10n.colorRed,
      'purple' => l10n.colorPurple,
      'yellow' => l10n.colorYellow,
      _ => color,
    };

/// UI counterpart of [PlayerEntity.displayName]: the typed name, or the
/// capitalized *localized* color for unnamed players.
extension PlayerEntityL10n on PlayerEntity {
  String localizedDisplayName(AppLocalizations l10n) =>
      name.isNotEmpty ? name : localizedColorName(l10n, color).capitalized;
}
