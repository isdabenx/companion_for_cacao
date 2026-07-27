import 'dart:async';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/shared/widgets/action_card_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

/// Home launchpad: a brand hero over the main destinations as large action
/// cards, with the app description and feature list tucked into an "About"
/// section so the first screen reads as a way in, not a wall of text.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String _repoUrl =
      'https://github.com/isdabenx/companion_for_cacao';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final actions = <ActionCardWidget>[
      ActionCardWidget(
        title: l10n.menuGameSetup,
        subtitle: l10n.homeCardSetupSub,
        icon: Icons.group,
        tone: ActionCardTone.green,
        onTap: () => context.go(AppRoutes.gameSetup),
      ),
      ActionCardWidget(
        title: l10n.menuTiles,
        subtitle: l10n.homeCardTilesSub,
        icon: Icons.widgets,
        onTap: () => context.go(AppRoutes.tiles),
      ),
      ActionCardWidget(
        title: l10n.menuScores,
        subtitle: l10n.homeCardScoresSub,
        icon: Icons.calculate,
        tone: ActionCardTone.green,
        onTap: () => context.go(AppRoutes.scoreCalculator),
      ),
      ActionCardWidget(
        title: l10n.menuRules,
        subtitle: l10n.homeCardRulesSub,
        icon: Icons.library_books,
        onTap: () => context.go(AppRoutes.rules),
      ),
    ];

    return UpgradeAlert(
      child: CustomScaffoldWidget(
        title: l10n.menuHome,
        // Option C: no cream panel — the cards sit directly on the leafy
        // backdrop, so white cards get maximum contrast and the green frames
        // the launchpad.
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.s,
            AppSpacing.l,
            AppSpacing.m,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.verticalS,
              // Brand hero: the decorative type lives in the logo, so the
              // lockup above it is a quiet letterspaced eyebrow instead of a
              // second display treatment competing with it.
              Text(
                'Companion for'.toUpperCase(),
                style: AppTextStyles.badge.copyWith(
                  fontSize: 12,
                  letterSpacing: 3,
                  color: AppColors.greenDarker,
                ),
                textAlign: TextAlign.center,
              ),
              Image.asset(Assets.cacaoTile, height: 132),
              AppSpacing.verticalS,
              Text(
                l10n.homeTagline,
                style: AppTextStyles.instruction,
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalXl,
              // Main destinations.
              for (var i = 0; i < actions.length; i++) ...[
                actions[i]
                    .animate()
                    .fadeIn(duration: 280.ms, delay: (70 * i).ms)
                    .slideY(
                      begin: 0.08,
                      end: 0,
                      duration: 280.ms,
                      delay: (70 * i).ms,
                      curve: Curves.easeOutCubic,
                    ),
                if (i < actions.length - 1) AppSpacing.verticalM,
              ],
              AppSpacing.verticalXl,
              _AboutSection(l10n: l10n, repoUrl: _repoUrl),
              AppSpacing.verticalM,
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.l10n, required this.repoUrl});

  final AppLocalizations l10n;
  final String repoUrl;

  @override
  Widget build(BuildContext context) {
    final features = <(IconData, String, String)>[
      (Icons.checklist_rtl, l10n.aboutFeaturePrep, l10n.aboutFeaturePrepSub),
      (
        Icons.calculate_outlined,
        l10n.aboutFeatureScore,
        l10n.aboutFeatureScoreSub,
      ),
      (
        Icons.grid_view_rounded,
        l10n.aboutFeatureTiles,
        l10n.aboutFeatureTilesSub,
      ),
      (
        Icons.menu_book_outlined,
        l10n.aboutFeatureRules,
        l10n.aboutFeatureRulesSub,
      ),
      (
        Icons.extension_outlined,
        l10n.aboutFeatureExpansions,
        l10n.aboutFeatureExpansionsSub,
      ),
      (Icons.language, l10n.aboutFeatureLangs, l10n.aboutFeatureLangsSub),
    ];
    final soon = <(IconData, String)>[
      (Icons.timer_outlined, l10n.aboutSoonTimer),
      (Icons.history, l10n.aboutSoonHistory),
      (Icons.tune, l10n.aboutSoonSettings),
    ];

    return Theme(
      // Drop the default ExpansionTile dividers so it blends into the panel.
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      // On the card surface like every other block on the launchpad, so the
      // section doesn't read as bare text dropped on the background.
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            0,
            AppSpacing.l,
            AppSpacing.l,
          ),
          title: Text(
            l10n.homeAboutTitle,
            style: AppTextStyles.boardgameTitlePlain,
          ),
          iconColor: AppColors.brown,
          collapsedIconColor: AppColors.brown,
          children: [
            // Identity strip, then the app's capabilities as tiles instead of
            // a bullet wall: this section describes the product, not a
            // developer changelog.
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: AppColors.greenDarker,
                    shape: AppShapes.shape(AppShapes.radiusM),
                  ),
                  child: Text(
                    'C',
                    style: AppTextStyles.titleTextStyle.copyWith(
                      fontSize: 26,
                      color: AppColors.white,
                      shadows: const [],
                    ),
                  ),
                ),
                AppSpacing.horizontalM,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name: brand, never translated.
                      Text(
                        'Companion for Cacao',
                        style: AppTextStyles.boardgameTitlePlain,
                      ),
                      const SizedBox(height: 4),
                      _Chip(label: l10n.aboutOpenSource),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.verticalM,
            _Panel(
              child: Text(l10n.aboutIntro, style: AppTextStyles.bodyMedium),
            ),
            AppSpacing.verticalL,
            _SectionLabel(text: l10n.aboutIncludedTitle),
            LayoutBuilder(
              builder: (context, constraints) {
                // Two columns on phones, three when there is room. Rows use
                // IntrinsicHeight so tiles in the same row match height even
                // when one description wraps to a second line.
                final columns = constraints.maxWidth > 520 ? 3 : 2;
                const gap = AppSpacing.s;
                final rows = <List<(IconData, String, String)>>[
                  for (var i = 0; i < features.length; i += columns)
                    features.sublist(
                      i,
                      (i + columns).clamp(0, features.length),
                    ),
                ];
                return Column(
                  children: [
                    for (final (rowIndex, row) in rows.indexed) ...[
                      if (rowIndex > 0) const SizedBox(height: gap),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (
                              var column = 0;
                              column < columns;
                              column++
                            ) ...[
                              if (column > 0) const SizedBox(width: gap),
                              Expanded(
                                child: column < row.length
                                    ? _FeatureTile(
                                        icon: row[column].$1,
                                        title: row[column].$2,
                                        subtitle: row[column].$3,
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            AppSpacing.verticalL,
            _SectionLabel(text: l10n.aboutInDevelopmentTitle),
            _Panel(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.m,
                vertical: AppSpacing.xs,
              ),
              child: Column(
                children: [
                  for (final (index, (icon, title)) in soon.indexed) ...[
                    if (index > 0)
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        color: AppColors.brown.withValues(alpha: 0.08),
                      ),
                    _SoonRow(
                      icon: icon,
                      title: title,
                      badge: l10n.aboutSoonBadge,
                    ),
                  ],
                ],
              ),
            ),
            AppSpacing.verticalL,
            _RepoButton(
              title: l10n.aboutRepoTitle,
              subtitle: l10n.aboutRepoSubtitle,
              onTap: () => unawaited(launchUrl(Uri.parse(repoUrl))),
            ),
            AppSpacing.verticalS,
            Text(
              l10n.aboutMadeWith,
              style: AppTextStyles.sectionSublabel,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Small pill label (open source, version…).
class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.greenLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.badge.copyWith(color: AppColors.greenDarker),
      ),
    );
  }
}

/// Uppercase group label above a block of the About section.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: AppSpacing.s),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.badge.copyWith(
          color: AppColors.greenDarker,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

/// One shipped capability: icon chip, name and a one-line description.
class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: AppColors.greenLight,
              shape: AppShapes.shape(AppShapes.radiusS),
            ),
            child: Icon(icon, size: 20, color: AppColors.greenDarker),
          ),
          AppSpacing.verticalS,
          Text(title, style: AppTextStyles.sectionTitle.copyWith(fontSize: 15)),
          const SizedBox(height: 2),
          Text(subtitle, style: AppTextStyles.sectionSublabel),
        ],
      ),
    );
  }
}

/// Inset block on the About card: cream fill with a hairline, so nested
/// blocks stay legible on the white card surface.
class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding = AppSpacing.allM});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        color: AppColors.cream,
        shape: AppShapes.shape(AppShapes.radiusM).copyWith(
          side: BorderSide(color: AppColors.brown.withValues(alpha: 0.08)),
        ),
      ),
      child: child,
    );
  }
}

/// One planned capability: muted, with a "soon" badge instead of a checkmark.
class _SoonRow extends StatelessWidget {
  const _SoonRow({
    required this.icon,
    required this.title,
    required this.badge,
  });

  final IconData icon;
  final String title;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.brown.withValues(alpha: 0.45)),
          AppSpacing.horizontalM,
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 15,
                color: AppColors.brown.withValues(alpha: 0.75),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badge.toUpperCase(),
              style: AppTextStyles.badge.copyWith(letterSpacing: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

/// The repository call to action — a real button instead of a raw URL.
class _RepoButton extends StatelessWidget {
  const _RepoButton({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.brown,
      shape: AppShapes.card,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.allM,
          child: Row(
            children: [
              const Icon(Icons.code, color: AppColors.white, size: 26),
              AppSpacing.horizontalM,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.sectionSublabel.copyWith(
                        color: AppColors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new,
                color: AppColors.white.withValues(alpha: 0.7),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
