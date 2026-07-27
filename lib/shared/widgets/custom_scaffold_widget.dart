import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/theme/app_breakpoints.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/widgets/main_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class CustomScaffoldWidget extends StatefulWidget {
  const CustomScaffoldWidget({
    required this.body,
    super.key,
    this.title,
    this.actions,
    this.showBackButton = false,
    this.appBarBottom,
  });
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final PreferredSizeWidget? appBarBottom;

  @override
  State<CustomScaffoldWidget> createState() => _CustomScaffoldWidgetState();
}

class _CustomScaffoldWidgetState extends State<CustomScaffoldWidget> {
  final AdvancedDrawerController drawerController = AdvancedDrawerController();

  @override
  void dispose() {
    drawerController.dispose();
    super.dispose();
  }

  double _getDrawerRatio(double width) {
    if (AppBreakpoints.isExpanded(width)) {
      return 0.35; // Desktop: smaller menu
    } else if (AppBreakpoints.isMedium(width)) {
      return 0.45; // Tablet: medium menu
    }
    return 0.65; // Mobile: full menu
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final drawerRatio = _getDrawerRatio(size.width);
    final isLandscape = size.width > size.height;

    return MainMenuWidget(
      drawerController: drawerController,
      openRatio: drawerRatio,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: isLandscape ? 44 : 56,
          bottom: widget.appBarBottom,
          actions: widget.actions,
          // Uppercased: the app-bar title is chrome, so it reads as a label
          // rather than competing with the content headings below it.
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text((widget.title ?? '').toUpperCase()),
          ),
          centerTitle: true,
          leading: widget.showBackButton
              ? null
              : Tooltip(
                  message: AppLocalizations.of(context).openMenuTooltip,
                  child: IconButton(
                    onPressed: () {
                      drawerController.showDrawer();
                    },
                    icon: const Icon(Icons.menu),
                  ),
                ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(Assets.background),
                  fit: BoxFit.cover,
                  // Warm cream wash over the leaf texture: the jungle stays a
                  // whisper, and content sits on a calm ground instead of a
                  // second green competing with the chrome and the cards.
                  colorFilter: ColorFilter.mode(
                    AppColors.cream.withValues(alpha: 0.9),
                    BlendMode.srcOver,
                  ),
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: widget.body,
              ),
            );
          },
        ),
      ),
    );
  }
}
