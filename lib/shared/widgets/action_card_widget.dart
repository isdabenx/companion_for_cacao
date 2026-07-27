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
/// Accent of the default icon chip. Alternating them down a list gives the
/// launchpad rhythm without introducing new colours.
enum ActionCardTone { gold, green }

class ActionCardWidget extends StatelessWidget {
  const ActionCardWidget({
    required this.title,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.tone = ActionCardTone.gold,
    this.leading,
    this.trailing,
    super.key,
  }) : assert(
         leading != null || icon != null,
         'Provide a leading widget or an icon',
       );

  final String title;
  final String? subtitle;

  /// Icon for the default chip; ignored when [leading] is given.
  final IconData? icon;

  /// Accent of the default icon chip.
  final ActionCardTone tone;

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
              leading ?? _IconChip(icon: icon!, tone: tone),
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

/// The default leading badge: a filled brand chip with a white glyph. The
/// solid fill (over the previous 22%-alpha wash) gives the card a focal point
/// and keeps the icon legible on the cream card surface.
class _IconChip extends StatelessWidget {
  const _IconChip({required this.icon, required this.tone});

  final IconData icon;
  final ActionCardTone tone;

  @override
  Widget build(BuildContext context) {
    final (List<Color> gradient, Color glyph) = switch (tone) {
      ActionCardTone.green => (
        [AppColors.greenDark, AppColors.greenDarker],
        AppColors.white,
      ),
      ActionCardTone.gold => (
        [AppColors.gold, AppColors.goldDark],
        AppColors.brown,
      ),
    };

    return Container(
      width: 48,
      height: 48,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: AppShapes.shape(AppShapes.radiusM),
        shadows: [
          BoxShadow(
            color: gradient.last.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: 26, color: glyph),
    );
  }
}
