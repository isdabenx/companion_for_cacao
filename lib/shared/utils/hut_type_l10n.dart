import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';

/// Localized display name for each [HutType], resolved through the app's
/// localizations instead of the entity's English [HutType.label].
extension HutTypeL10n on HutType {
  String localizedName(AppLocalizations l10n) {
    return switch (this) {
      HutType.marketCrier => l10n.hutMarketCrier,
      HutType.hermit => l10n.hutHermit,
      HutType.roadWorker => l10n.hutRoadWorker,
      HutType.trader => l10n.hutTrader,
      HutType.farmer => l10n.hutFarmer,
      HutType.shaman => l10n.hutShaman,
      HutType.monk => l10n.hutMonk,
      HutType.masterBuilder => l10n.hutMasterBuilder,
      HutType.foreman => l10n.hutForeman,
      HutType.fountainMaster => l10n.hutFountainMaster,
      HutType.chiefsDaughter => l10n.hutChiefsDaughter,
      HutType.chiefsSon => l10n.hutChiefsSon,
      HutType.chiefsWife => l10n.hutChiefsWife,
      HutType.chief => l10n.hutChief,
    };
  }
}
