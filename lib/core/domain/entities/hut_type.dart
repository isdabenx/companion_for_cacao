/// The 14 hut functions from the Chocolatl Hut Module.
///
/// At the end of the game each built hut refunds its building [cost] and may
/// grant an additional bonus. Bonuses fall into three groups:
/// - [fixedBonus]: a flat amount of gold (Chief's family, and none for huts
///   whose benefit applies only during the game).
/// - Derived bonuses computed by the calculator from other inputs
///   (Fountain Master, Trader, Monk, Master Builder).
/// - Manual-count bonuses that need the player to count something on the
///   board ([needsManualCount]: Hermit and Road Worker).
enum HutType {
  marketCrier('Market Crier', 4),
  hermit('Hermit', 6, needsManualCount: true),
  roadWorker('Road Worker', 6, needsManualCount: true),
  trader('Trader', 6),
  farmer('Farmer', 8),
  shaman('Shaman', 8),
  monk('Monk', 10),
  masterBuilder('Master Builder', 10),
  foreman('Foreman', 12),
  fountainMaster('Fountain Master', 12),
  chiefsDaughter("Chief's Daughter", 14, fixedBonus: 4),
  chiefsSon("Chief's Son", 16, fixedBonus: 4),
  chiefsWife("Chief's Wife", 20, fixedBonus: 5),
  chief('Chief', 24, fixedBonus: 6);

  const HutType(
    this.label,
    this.cost, {
    this.fixedBonus = 0,
    this.needsManualCount = false,
  });

  final String label;

  /// Building cost paid during the game, refunded at final scoring.
  final int cost;

  /// Flat end-game bonus (0 when the hut has none or it is derived).
  final int fixedBonus;

  /// True when the bonus requires counting something on the physical board
  /// (Hermit: own workers without an adjacent jungle tile; Road Worker: own
  /// worker tiles in the best row or column).
  final bool needsManualCount;
}
