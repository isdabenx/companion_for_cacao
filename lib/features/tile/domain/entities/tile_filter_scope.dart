/// Independent scopes for the tile filter state.
///
/// The tile catalog browser and the in-game "Tiles in Play" screen serve
/// different mental contexts (exploring the collection vs. finding pieces
/// of the current game), so each keeps its own filter — a filter left on
/// in the catalog must never silently hide tiles from a running game.
enum TileFilterScope { catalog, inPlay }
