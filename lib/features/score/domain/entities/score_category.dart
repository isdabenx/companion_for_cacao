/// Categories that contribute gold to a player's final score.
enum ScoreCategory {
  accumulatedGold('Accumulated Gold'),
  waterTrack('Water Track'),
  temples('Temples'),
  sunTokens('Sun Tokens'),
  huts('Huts'),
  gemMines('Gem Mines');

  const ScoreCategory(this.label);

  final String label;
}
