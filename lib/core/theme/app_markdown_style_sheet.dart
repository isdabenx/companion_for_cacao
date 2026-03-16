import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class AppMarkdownStyleSheet {
  static MarkdownStyleSheet styleSheet = MarkdownStyleSheet(
    strong: AppTextStyles.markdownBold,
    p: AppTextStyles.markdownBody,
  );
}
