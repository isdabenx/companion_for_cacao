import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// A manual on its own screen, for a window with no room to show it beside
/// the index.
class RulePdfScreen extends StatelessWidget {
  const RulePdfScreen({required this.pdfPath, required this.title, super.key});

  final String title;
  final String pdfPath;

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: title,
      showBackButton: true,
      body: RulePdfView(pdfPath: pdfPath),
    );
  }
}

/// The page itself. Free of any scaffold so the same reader serves the pushed
/// screen and the pane beside the index.
class RulePdfView extends StatelessWidget {
  const RulePdfView({required this.pdfPath, super.key});

  final String pdfPath;

  @override
  Widget build(BuildContext context) => SfPdfViewer.asset(pdfPath);
}
