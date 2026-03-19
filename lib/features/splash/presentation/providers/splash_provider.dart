import 'package:companion_for_cacao/core/providers/repository_providers.dart';
import 'package:companion_for_cacao/features/splash/domain/use_cases/initialize_app_use_case.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.g.dart';

@Riverpod(keepAlive: true)
InitializeAppUseCase initializeAppUseCase(Ref ref) {
  return InitializeAppUseCase(ref.watch(initializationRepositoryProvider));
}

@Riverpod(keepAlive: true)
Future<void> splashScreen(Ref ref) async {
  final initializeAppUseCase = ref.read(initializeAppUseCaseProvider);
  await initializeAppUseCase.initialize();
  // Ensure boardgames are loaded before navigating away from splash
  await ref.read(boardgameProvider.future);
}
