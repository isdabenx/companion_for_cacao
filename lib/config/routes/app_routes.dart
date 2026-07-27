class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String tiles = '/tiles';
  static const String tileDetail = '/tile_detail';
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
