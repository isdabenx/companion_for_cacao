import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// The strip above a detail pane: what is showing, and the two ways out of it.
///
/// Two controls because there are two things you might want — out of the pane
/// entirely, or the pane on its own for a closer look. Neither is the system
/// back: nothing was pushed to open a pane, so there is nothing to go back
/// from, and offering an arrow here would promise a history that does not
/// exist.
class DetailPaneHeader extends StatelessWidget {
  const DetailPaneHeader({
    required this.title,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onClose,
    super.key,
  });

  final String title;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.s,
        right: AppSpacing.xs,
        top: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            tooltip: isExpanded
                ? l10n.detailPaneCollapse
                : l10n.detailPaneExpand,
            onPressed: onToggleExpanded,
            icon: Icon(
              isExpanded ? Icons.close_fullscreen : Icons.open_in_full,
              color: AppColors.brown,
              size: 20,
            ),
          ),
          IconButton(
            tooltip: l10n.detailPaneClose,
            onPressed: onClose,
            icon: const Icon(Icons.close, color: AppColors.brown, size: 20),
          ),
        ],
      ),
    );
  }
}
