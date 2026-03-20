import 'dart:async';

import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:go_router/go_router.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({required this.drawerController, super.key});
  final AdvancedDrawerController drawerController;

  void _onTapped(VoidCallback action) {
    drawerController.hideDrawer();
    unawaited(Future.delayed(const Duration(milliseconds: 240), action));
  }

  void _navigateTo(BuildContext context, String route) {
    _onTapped(() => context.go(route));
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.iconColor),
      title: Text(title, style: AppTextStyles.menuItem),
      onTap: () => _navigateTo(context, route),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.menuBackground,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 55),
                child: Text('Menu', style: AppTextStyles.loadingTextStyle),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _menuItem(context, Icons.home, 'Home', AppRoutes.home),
                  _menuItem(
                    context,
                    Icons.group,
                    'Game setup',
                    AppRoutes.gameSetup,
                  ),
                  _menuItem(context, Icons.widgets, 'Tiles', AppRoutes.tiles),
                  _menuItem(
                    context,
                    Icons.library_books,
                    'Rules',
                    AppRoutes.rules,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
