import 'package:companion_for_cacao/config/providers/initialization_provider.dart';
import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// The database, once [InitializationRepository] has opened and seeded it.
///
/// `watch`, not `read`: a dependency read inside `build` is invisible to
/// Riverpod, so the database would keep handing out a connection from a
/// repository that had been replaced underneath it — including in tests,
/// where the repository is overridden.
@Riverpod(keepAlive: true)
Future<AppDatabase> database(Ref ref) async {
  final initializationRepository = ref.watch(initializationRepositoryProvider);
  return initializationRepository.getDatabase();
}
