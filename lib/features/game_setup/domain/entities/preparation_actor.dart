/// Who performs a preparation step.
///
/// When [player], the step's `color` identifies which player; the UI groups
/// those steps into that player's card. [allPlayers] steps are done by
/// everyone at once (e.g. shuffling worker piles) and [table] steps are
/// shared table work (piles, display, supplies).
enum PreparationActor { player, allPlayers, table }
