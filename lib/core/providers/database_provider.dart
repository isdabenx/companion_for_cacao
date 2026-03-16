import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/core/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  final initializationRepository = ref.read(initializationRepositoryProvider);
  return initializationRepository.getDatabase();
});
