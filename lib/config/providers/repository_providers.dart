import 'package:companion_for_cacao/config/providers/database_provider.dart';
import 'package:companion_for_cacao/core/data/repositories/boardgame_repository_impl.dart';
import 'package:companion_for_cacao/core/data/repositories/settings_repository_impl.dart';
import 'package:companion_for_cacao/core/domain/repositories/boardgame_repository.dart';
import 'package:companion_for_cacao/core/domain/repositories/settings_repository.dart';
import 'package:companion_for_cacao/features/game_setup/data/repositories/custom_preset_repository_impl.dart';
import 'package:companion_for_cacao/features/game_setup/domain/repositories/custom_preset_repository.dart';
import 'package:companion_for_cacao/features/tile/data/repositories/tile_repository_impl.dart';
import 'package:companion_for_cacao/features/tile/domain/repositories/tile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

/// Composition root: all repository providers wired in one place.
/// This file is intentionally placed in config/ (app-level) rather than core/
/// because it wires feature implementations to their interfaces, which requires
/// importing from features.
///
/// ## Why every provider in this app is `keepAlive`
///
/// This is the root of that chain, so the reasoning lives here once instead of
/// being repeated at each of the ~24 declarations.
///
/// Three forces make it the correct default *for this app*:
///
/// 1. **Infrastructure must outlive screens.** The database connection and the
///    repositories built on it would otherwise be torn down and reopened
///    whenever no screen happened to be watching them.
/// 2. **Session state must survive navigation.** `gameSetupProvider` holds the
///    game in progress — players, tiles and which preparation steps are ticked.
///    Under `autoDispose`, leaving Preparation to check the rules and coming
///    back would silently discard it. The same goes for `scoreProvider`.
/// 3. **riverpod_lint propagates it.** `only_use_keep_alive_inside_keep_alive`
///    forbids a long-lived provider from depending on a disposable one, since it
///    would hold state that can vanish underneath it. Once the database is
///    `keepAlive`, everything above it has to be.
///
/// The usual argument for `autoDispose` is freeing memory, and it does not bite
/// here: these providers hold entity lists and flags (kilobytes), not images or
/// per-item `family` state that would accumulate while browsing. A new provider
/// holding anything heavy, or keyed per item, should reconsider this default.

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepositoryImpl();
}

@Riverpod(keepAlive: true)
CustomPresetRepository customPresetRepository(Ref ref) {
  return CustomPresetRepositoryImpl();
}

@Riverpod(keepAlive: true)
Future<TileRepository> tileRepository(Ref ref) async {
  final database = await ref.watch(databaseProvider.future);
  return TileRepositoryImpl(database);
}

@Riverpod(keepAlive: true)
Future<BoardgameRepository> boardgameRepository(Ref ref) async {
  final database = await ref.watch(databaseProvider.future);
  return BoardgameRepositoryImpl(database);
}
