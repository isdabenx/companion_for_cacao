import 'package:companion_for_cacao/core/data/repositories/boardgame_repository.dart';
import 'package:companion_for_cacao/core/data/repositories/boardgame_repository_impl.dart';
import 'package:companion_for_cacao/core/providers/database_provider.dart';
import 'package:companion_for_cacao/features/splash/data/repositories/initialization_repository_impl.dart';
import 'package:companion_for_cacao/features/splash/domain/repositories/initialization_repository.dart';
import 'package:companion_for_cacao/features/tile/data/repositories/tile_repository.dart';
import 'package:companion_for_cacao/features/tile/data/repositories/tile_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Composition root: all repository providers wired in one place.

final initializationRepositoryProvider = Provider<InitializationRepository>(
  (ref) => InitializationRepositoryImpl(),
);

final tileRepositoryProvider = FutureProvider<TileRepository>((ref) async {
  final database = await ref.watch(databaseProvider.future);
  return TileRepositoryImpl(database);
});

final boardgameRepositoryProvider = FutureProvider<BoardgameRepository>((
  ref,
) async {
  final database = await ref.watch(databaseProvider.future);
  return BoardgameRepositoryImpl(database);
});
