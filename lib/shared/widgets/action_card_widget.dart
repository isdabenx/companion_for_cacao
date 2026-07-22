import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// A large, tappable row-card: a leading badge, a branded title (optional
/// subtitle) and a trailing affordance, on the shared card surface (colour,
/// squircle and shadow come from the global `cardTheme`, so every card stays
/// consistent). Shared by the Home launchpad, the game dashboard and the
/// rules list.
///
/// By default the leading is a soft gold icon chip built from [icon] and the
/// trailing is a chevron; pass [leading] / [trailing] to override (e.g. a
/// cover image and a PDF icon on the rules screen).
class ActionCardWidget extends StatelessWidget {
  const ActionCardWidget({
    required this.title,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.leading,
    this.trailing,
    super.key,
  }) : assert(
         leading != null || icon != null,
         'Provide a leading widget or an icon',
       );

  final String title;
  final String? subtitle;

  /// Icon for the default gold chip; ignored when [leading] is given.
  final IconData? icon;

  /// Custom leading widget (a cover image, avatar…). Falls back to the gold
  /// icon chip built from [icon].
  final Widget? leading;

  /// Custom trailing widget. Falls back to a chevron.
  final Widget? trailing;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        customBorder: AppShapes.card,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.l,
            horizontal: AppSpacing.l,
          ),
          child: Row(
            children: [
              leading ?? _GoldIconChip(icon: icon!),
              AppSpacing.horizontalL,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.boardgameTitlePlain.copyWith(
                        fontSize: 20,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: AppTextStyles.sectionSublabel),
                    ],
                  ],
                ),
              ),
              trailing ??
                  const Icon(Icons.chevron_right, color: AppColors.brown),
            ],
          ),
        ),
      ),
    );
  }
}

/// The default leading badge: a soft gold chip with a brand-green icon.
class _GoldIconChip extends StatelessWidget {
  const _GoldIconChip({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: ShapeDecoration(
        // A gentle brand accent that doesn't shout.
        color: AppColors.gold.withValues(alpha: 0.22),
        shape: AppShapes.shape(AppShapes.radiusM),
      ),
      child: Icon(icon, size: 26, color: AppColors.greenDarker),
    );
  }
}
