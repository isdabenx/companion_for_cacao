import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class RulePdfScreen extends StatelessWidget {
  const RulePdfScreen({required this.pdfPath, required this.title, super.key});
  final String title;
  final String pdfPath;

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: title,
      showBackButton: true,
      body: SfPdfViewer.asset(pdfPath),
    );
  }
}
