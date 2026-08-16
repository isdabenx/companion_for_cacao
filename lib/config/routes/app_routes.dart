class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String tiles = '/tiles';

  /// Nested under [tiles] on purpose: a destination's sub-screens have to sit
  /// inside its branch to be pushed onto that branch's navigator, which is
  /// what keeps the menu on screen and the section's place remembered.
  static const String tileDetail = '/tiles/detail';
  static const String rules = '/rules';
  static const String rulePdf = '/rules/pdf';
  static const String gameSetup = '/game_setup';
  static const String gameSetupDetail = '/game_setup/detail';
  static const String gameSetupPreparation = '/game_setup/detail/preparation';
  static const String gameSetupTiles = '/game_setup/detail/tiles';
  static const String scoreCalculator = '/score_calculator';
  static const String scoreResult = '/score_calculator/result';

  /// Every route above, so the routing test can assert the table is complete
  /// instead of re-listing the paths somewhere it can drift from. A new
  /// constant belongs here too, right below its declaration.
  static const List<String> all = [
    splash,
    home,
    tiles,
    tileDetail,
    rules,
    rulePdf,
    gameSetup,
    gameSetupDetail,
    gameSetupPreparation,
    gameSetupTiles,
    scoreCalculator,
    scoreResult,
  ];
}
