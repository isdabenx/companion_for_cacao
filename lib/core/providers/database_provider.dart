import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/core/providers/initialization_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
Future<AppDatabase> database(Ref ref) async {
  final initializationRepository = ref.read(initializationRepositoryProvider);
  return initializationRepository.getDatabase();
}
