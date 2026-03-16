import 'dart:ui';

import 'package:flutter/widgets.dart';

class BlurFilterWidget extends StatelessWidget {
  const BlurFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: const SizedBox.expand(),
      ),
    );
  }
}
