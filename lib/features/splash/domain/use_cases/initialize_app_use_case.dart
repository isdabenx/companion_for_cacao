import 'package:companion_for_cacao/features/splash/domain/repositories/initialization_repository.dart';

class InitializeAppUseCase {
  InitializeAppUseCase(this.repository);
  final InitializationRepository repository;

  Future<void> initialize() async {
    await repository.initialize();
  }
}
