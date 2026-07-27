import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';

extension PreparationPhaseL10n on PreparationPhase {
  String localizedName(AppLocalizations l10n) => switch (this) {
    PreparationPhase.tilePool => l10n.phaseTilePool,
    PreparationPhase.playerSetup => l10n.phasePlayerSetup,
    PreparationPhase.boardSetup => l10n.phaseBoardSetup,
    PreparationPhase.supplies => l10n.phaseSupplies,
  };
}
