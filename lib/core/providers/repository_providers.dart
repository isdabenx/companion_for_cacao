import 'package:companion_for_cacao/core/data/repositories/boardgame_repository.dart';
import 'package:companion_for_cacao/core/data/repositories/boardgame_repository_impl.dart';
import 'package:companion_for_cacao/core/data/repositories/settings_repository.dart';
import 'package:companion_for_cacao/core/data/repositories/settings_repository_impl.dart';
import 'package:companion_for_cacao/core/providers/database_provider.dart';
import 'package:companion_for_cacao/features/tile/data/repositories/tile_repository.dart';
import 'package:companion_for_cacao/features/tile/data/repositories/tile_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

/// Composition root: all repository providers wired in one place.

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepositoryImpl();
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
