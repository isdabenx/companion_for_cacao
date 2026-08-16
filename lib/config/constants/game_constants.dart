/// Game-level constants used across the application.
class GameConstants {
  GameConstants._();

  /// The ID of the base game (Cacao) in the database.
  static const int baseGameId = 1;

  /// The ID of the Chocolatl expansion.
  static const int chocolatlExpansionId = 2;

  /// The ID of the Diamante expansion.
  static const int diamanteExpansionId = 3;

  /// The player colours the game ships, in their canonical order.
  ///
  /// This is game data, not styling: it decides the default turn order and
  /// which colours a game can use. The palette that paints them lives in
  /// `AppColors` (see the guard in `test/config/constants/`), so the domain
  /// never has to reach into the theme to learn the order.
  static const List<String> playerColorOrder = [
    'white',
    'red',
    'purple',
    'yellow',
  ];

  /// Minimum number of players required to start a game.
  static const int minPlayers = 2;

  /// Maximum number of players.
  static const int maxPlayers = 4;
}
