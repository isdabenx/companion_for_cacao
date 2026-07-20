/// Where on the table the result of a preparation step ends up.
///
/// Purely informative in UX-1; the UX-2 table map renders steps by zone.
enum TableZone {
  /// A player's own corner: village board, water carrier, worker tiles.
  playerArea,

  /// The face-down jungle draw pile (including tiles added to it).
  junglePile,

  /// The face-up jungle display next to the pile (and the map board).
  jungleDisplay,

  /// Supply piles: cacao, suns, coins, chocolate, gems, masks, huts.
  supplies,

  /// The starting tiles at the center of the playing area.
  startingArea,

  /// Back into the game box (removed components).
  box,
}
