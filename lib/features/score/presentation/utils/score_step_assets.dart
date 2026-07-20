import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/features/score/domain/entities/hut_type.dart';
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

/// Tile image of each hut function (same art as the tile catalog).
extension HutTypeAssets on HutType {
  String get imageAsset {
    final filename = switch (this) {
      HutType.marketCrier => 'hut_market_crier',
      HutType.hermit => 'hut_hermit',
      HutType.roadWorker => 'hut_road_worker',
      HutType.trader => 'hut_trader',
      HutType.farmer => 'hut_farmer',
      HutType.shaman => 'hut_shaman',
      HutType.monk => 'hut_monk',
      HutType.masterBuilder => 'hut_master_builder',
      HutType.foreman => 'hut_foreman',
      HutType.fountainMaster => 'hut_fountain_master',
      HutType.chiefsDaughter => 'hut_chief_s_daughter',
      HutType.chiefsSon => 'hut_chief_s_son',
      HutType.chiefsWife => 'hut_chief_s_wife',
      HutType.chief => 'hut_chief',
    };
    return '${Assets.imagesTilePath}chocolatl/$filename.webp';
  }
}
