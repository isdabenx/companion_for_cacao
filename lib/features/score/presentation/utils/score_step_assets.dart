import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_state_entity.dart';

/// Reference image shown at the top of a score step, so the user sees the
/// physical component they have to count. Null when no image helps (player
/// selection) or the step provides its own images (huts, gem masks).
String? scoreStepReferenceImage(ScoreStep step) {
  return switch (step) {
    ScoreStep.setup => null,
    ScoreStep.accumulatedGold => Assets.resourcesGold,
    // The village board shows the water track with its field values.
    ScoreStep.waterTrack =>
      '${Assets.preparationVillagePrefix}red${Assets.preparationVillageSufix}',
    ScoreStep.temples => Assets.jungleTemple,
    ScoreStep.sunTokens => Assets.resourcesSunToken,
    ScoreStep.cacaoFruits => Assets.resourcesCacaoFruits,
    ScoreStep.huts => null,
    ScoreStep.gemMines => null,
  };
}
