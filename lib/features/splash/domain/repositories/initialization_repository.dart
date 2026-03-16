import 'package:companion_for_cacao/core/data/database/app_database.dart';

abstract class InitializationRepository {
  Future<void> initialize();
  AppDatabase getDatabase();
}
