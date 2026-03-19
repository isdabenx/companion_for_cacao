import 'dart:async';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/splash/presentation/providers/splash_provider.dart';
import 'package:companion_for_cacao/features/splash/presentation/widgets/background_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _backgroundFade;
  late final Animation<double> _indicatorFade;
  late final Animation<double> _indicatorScale;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Background image: fade in (0.0 – 0.4)
    _backgroundFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    );

    // CircularProgressIndicator: fade in + scale up (0.3 – 0.7)
    _indicatorFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
    );
    _indicatorScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOutBack),
    );

    // "Loading..." text: fade in + slide up from bottom (0.5 – 1.0)
    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
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

    final size = MediaQuery.sizeOf(context);
    const imageAspectRatio =
        Assets.splashBackgroundWidth / Assets.splashBackgroundHeight;
    final imageHeight = size.width / imageAspectRatio;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _backgroundFade,
              child: const BackgroundImageWidget(),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _indicatorFade,
              child: ScaleTransition(
                scale: _indicatorScale,
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
          Positioned(
            top: imageHeight,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _textFade,
              child: SlideTransition(
                position: _textSlide,
                child: SizedBox(
                  width: size.width,
                  child: Center(
                    child: Text(
                      'Loading...',
                      style: AppTextStyles.loadingTextStyle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
