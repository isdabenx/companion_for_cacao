import 'package:companion_for_cacao/core/providers/repository_providers.dart';
import 'package:companion_for_cacao/features/splash/domain/use_cases/initialize_app_use_case.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initializeAppUseCaseProvider = Provider<InitializeAppUseCase>(
  (ref) => InitializeAppUseCase(ref.watch(initializationRepositoryProvider)),
);

final splashScreenProvider = FutureProvider<void>((ref) async {
  final initializeAppUseCase = ref.read(initializeAppUseCaseProvider);
  await initializeAppUseCase.initialize();
  final boardgameNotifier = ref.read(boardgameNotifierProvider.notifier);
  await boardgameNotifier.initialize();
});
