import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/features/splash/presentation/widgets/mirrored_image_widget.dart';
import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatelessWidget {
  const BackgroundImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(Assets.splashBackground),
        const MirroredImageWidget(),
      ],
    );
  }
}
