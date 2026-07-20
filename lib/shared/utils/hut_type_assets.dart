import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';

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
