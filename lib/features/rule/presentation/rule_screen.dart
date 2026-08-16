import 'dart:async';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_breakpoints.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/rule/presentation/rule_pdf_screen.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/widgets/action_card_widget.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/shared/widgets/detail_pane_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// One manual in the index.
@immutable
class _RuleDoc {
  const _RuleDoc({
    required this.title,
    required this.pdfPath,
    required this.imagePath,
  });

  final String title;
  final String pdfPath;
  final String imagePath;
}

/// A section of the index, with the documents under it.
@immutable
class _RuleSection {
  const _RuleSection({required this.header, required this.docs});

  final String header;
  final List<_RuleDoc> docs;
}

/// The manuals, with the open one beside the index when there is room.
///
/// Narrow, opening a manual is a trip to a reader and back, so comparing the
/// base rules against an expansion's means leaving one to fetch the other.
/// Wide, the index stays put and the reader fills the pane: switching document
/// is one tap and you never lose your place in the list.
class RuleScreen extends StatefulWidget {
  const RuleScreen({super.key});

  @override
  State<RuleScreen> createState() => _RuleScreenState();
}

class _RuleScreenState extends State<RuleScreen> {
  _RuleDoc? _open;
  bool _readerExpanded = false;

  /// Below this the index and a readable page cannot both fit, so the reader
  /// goes back to being its own screen.
  static const double _twoPaneFrom = AppBreakpoints.mediumMin;

  void _openDoc(_RuleDoc doc) => setState(() {
    // Choosing the manual already open closes it, so the same tap does both.
    _open = doc.pdfPath == _open?.pdfPath ? null : doc;
    _readerExpanded = false;
  });

  void _close() => setState(() {
    _open = null;
    _readerExpanded = false;
  });

  List<_RuleSection> _sections(AppLocalizations l10n) => [
    _RuleSection(
      header: l10n.rulesBaseGame,
      docs: [
        _RuleDoc(
          title: l10n.rulesInstructions,
          pdfPath: Assets.ruleCacaoPdf,
          imagePath: Assets.boardgameCacao,
        ),
        _RuleDoc(
          title: l10n.rulesOverview,
          pdfPath: Assets.ruleCacaoOverviewPdf,
          imagePath: Assets.boardgameCacao,
        ),
      ],
    ),
    _RuleSection(
      header: l10n.rulesExpansionHeader(l10n.expansionNameChocolatl),
      docs: [
        _RuleDoc(
          title: l10n.rulesExpansionRules(l10n.expansionNameChocolatl),
          pdfPath: Assets.ruleCacaoChocolatlPdf,
          imagePath: Assets.boardgameChocolatl,
        ),
      ],
    ),
    _RuleSection(
      header: l10n.rulesExpansionHeader(l10n.expansionNameDiamante),
      docs: [
        _RuleDoc(
          title: l10n.rulesExpansionRules(l10n.expansionNameDiamante),
          pdfPath: Assets.ruleCacaoDiamantePdf,
          imagePath: Assets.boardgameDiamante,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CustomScaffoldWidget(
      // Uncapped: wide enough, the index and the reader share the width, and a
      // reading column would leave no room for the page itself.
      contentWidth: ContentWidth.full,
      title: l10n.menuRules,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final twoPane = constraints.maxWidth >= _twoPaneFrom;
          final open = _open;
          final index = _Index(
            sections: _sections(l10n),
            openPdfPath: twoPane ? open?.pdfPath : null,
            onOpen: twoPane ? _openDoc : null,
          );

          if (!twoPane || open == null) return index;

          return Row(
            children: [
              if (!_readerExpanded) Expanded(flex: 2, child: index),
              Expanded(
                flex: _readerExpanded ? 1 : 3,
                child: Column(
                  children: [
                    DetailPaneHeader(
                      title: open.title,
                      isExpanded: _readerExpanded,
                      onToggleExpanded: () =>
                          setState(() => _readerExpanded = !_readerExpanded),
                      onClose: _close,
                    ),
                    // Keyed on the document: the viewer holds a page and a
                    // zoom, and switching manuals has to start the new one at
                    // its beginning rather than inherit where you were in the
                    // last.
                    Expanded(
                      child: RulePdfView(
                        key: ValueKey(open.pdfPath),
                        pdfPath: open.pdfPath,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Index extends StatelessWidget {
  const _Index({
    required this.sections,
    required this.openPdfPath,
    required this.onOpen,
  });

  final List<_RuleSection> sections;
  final String? openPdfPath;
  final void Function(_RuleDoc doc)? onOpen;

  @override
  Widget build(BuildContext context) {
    return ContainerFullStyleWidget(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final section in sections) ...[
              _header(section.header),
              for (final doc in section.docs) ...[
                _card(context, doc),
                AppSpacing.verticalM,
              ],
              AppSpacing.verticalM,
            ],
          ],
        ),
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.m,
        horizontal: AppSpacing.xs,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.sectionTitle.copyWith(
          fontSize: 15,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _card(BuildContext context, _RuleDoc doc) {
    final isOpen = doc.pdfPath == openPdfPath;

    // Shared card component: same surface as everywhere else, with a cover
    // thumbnail as the leading badge and a PDF glyph as the trailing.
    return ActionCardWidget(
      title: doc.title,
      leading: CircleAvatar(
        backgroundImage: AssetImage(doc.imagePath),
        radius: 24,
      ),
      // The one being read is marked, so the reader and the entry it came
      // from stay visibly tied together.
      trailing: Icon(
        isOpen ? Icons.visibility : Icons.picture_as_pdf,
        color: AppColors.greenDarker,
      ),
      onTap: () {
        if (onOpen != null) {
          onOpen!(doc);
          return;
        }
        unawaited(
          context.push(
            AppRoutes.rulePdf,
            extra: <String, String>{'title': doc.title, 'pdfPath': doc.pdfPath},
          ),
        );
      },
    );
  }
}
