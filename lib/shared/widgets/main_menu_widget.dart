import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/shared/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class MainMenuWidget extends StatelessWidget {
  const MainMenuWidget({
    required this.child,
    required this.drawerController,
    required this.openRatio,
    super.key,
  });
  final Scaffold child;
  final AdvancedDrawerController drawerController;
  final double openRatio;

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: drawerController,
      drawer: MenuWidget(drawerController: drawerController),
      openRatio: openRatio,
      openScale: 0.9,
      animateChildDecoration: true,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
      ),
      backdrop: const ColoredBox(color: AppColors.menuBackground),
      child: child,
    );
  }
}
