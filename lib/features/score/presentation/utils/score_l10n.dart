import 'package:companion_for_cacao/features/score/domain/entities/score_category.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_state_entity.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';

/// Localized titles for the score calculator steps.
extension ScoreStepL10n on ScoreStep {
  String localizedName(AppLocalizations l10n) => switch (this) {
    ScoreStep.setup => l10n.scoreStepSetup,
    ScoreStep.accumulatedGold => l10n.scoreCatGold,
    ScoreStep.waterTrack => l10n.scoreCatWater,
    ScoreStep.temples => l10n.scoreCatTemples,
    ScoreStep.sunTokens => l10n.scoreCatSun,
    ScoreStep.cacaoFruits => l10n.scoreCatCacao,
    ScoreStep.huts => l10n.scoreCatHuts,
    ScoreStep.gemMines => l10n.scoreCatGemMines,
  };
}

/// Localized labels for the gold breakdown categories.
extension ScoreCategoryL10n on ScoreCategory {
  String localizedName(AppLocalizations l10n) => switch (this) {
    ScoreCategory.accumulatedGold => l10n.scoreCatGold,
    ScoreCategory.waterTrack => l10n.scoreCatWater,
    ScoreCategory.temples => l10n.scoreCatTemples,
    ScoreCategory.sunTokens => l10n.scoreCatSun,
    ScoreCategory.huts => l10n.scoreCatHuts,
    ScoreCategory.gemMines => l10n.scoreCatGemMines,
  };
}
