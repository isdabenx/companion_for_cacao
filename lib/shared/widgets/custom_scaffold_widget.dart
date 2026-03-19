import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/theme/app_breakpoints.dart';
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
    final width = MediaQuery.sizeOf(context).width;
    final drawerRatio = _getDrawerRatio(width);

    return MainMenuWidget(
      drawerController: drawerController,
      openRatio: drawerRatio,
      child: Scaffold(
        appBar: AppBar(
          bottom: widget.appBarBottom,
          actions: widget.actions,
          title: Text(widget.title ?? ''),
          centerTitle: true,
          leading: widget.showBackButton
              ? null
              : Tooltip(
                  message: 'Open menu',
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.background),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    maxWidth: AppBreakpoints.medium,
                  ),
                  child: widget.body,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
