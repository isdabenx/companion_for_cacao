import 'dart:async';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/splash/presentation/providers/splash_provider.dart';
import 'package:companion_for_cacao/features/splash/presentation/widgets/background_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  void _enableImmersiveMode() {
    unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive));
  }

  void _disableImmersiveMode() {
    unawaited(
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
        .watch(splashScreenProvider)
        .when(
          data: (_) {
            _disableImmersiveMode();
          },
          loading: _enableImmersiveMode,
          error: (error, _) {
            _disableImmersiveMode();
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $error')));
            });
          },
        );

    final size = MediaQuery.of(context).size;
    const imageAspectRatio =
        Assets.splashBackgroundWidth / Assets.splashBackgroundHeight;
    final imageHeight = size.width / imageAspectRatio;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _BackgroundImage(),
          const Center(child: CircularProgressIndicator()),
          _LoadingText(top: imageHeight, width: size.width),
        ],
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: BackgroundImageWidget(),
    );
  }
}

class _LoadingText extends StatelessWidget {
  const _LoadingText({required this.top, required this.width});

  final double top;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      child: SizedBox(
        width: width,
        child: Center(
          child: Text('Loading...', style: AppTextStyles.loadingTextStyle),
        ),
      ),
    );
  }
}
