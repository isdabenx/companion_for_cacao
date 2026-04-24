import 'package:companion_for_cacao/features/splash/data/repositories/initialization_repository_impl.dart';
import 'package:companion_for_cacao/features/splash/domain/repositories/initialization_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'initialization_provider.g.dart';

@Riverpod(keepAlive: true)
InitializationRepository initializationRepository(Ref ref) {
  return InitializationRepositoryImpl();
}
