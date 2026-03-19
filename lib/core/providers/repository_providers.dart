import 'package:companion_for_cacao/core/data/repositories/boardgame_repository.dart';
import 'package:companion_for_cacao/core/data/repositories/boardgame_repository_impl.dart';
import 'package:companion_for_cacao/core/providers/database_provider.dart';
import 'package:companion_for_cacao/features/splash/data/repositories/initialization_repository_impl.dart';
import 'package:companion_for_cacao/features/splash/domain/repositories/initialization_repository.dart';
import 'package:companion_for_cacao/features/tile/data/repositories/tile_repository.dart';
import 'package:companion_for_cacao/features/tile/data/repositories/tile_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

/// Composition root: all repository providers wired in one place.

@Riverpod(keepAlive: true)
InitializationRepository initializationRepository(Ref ref) {
  return InitializationRepositoryImpl();
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
