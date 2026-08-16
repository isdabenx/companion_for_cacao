import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  // ============================================
  // BASE STYLES
  // ============================================

  static const double _offset = 0.7;

  // Hero title base — the decorative font WITH the gold "sticker" outline.
  // Reserved for display/brand moments (splash, menu title, big screen
  // titles); the outline muddies at small sizes so it is not reused there.
  static const TextStyle _titleBase = TextStyle(
    letterSpacing: 2,
    fontFamily: AppFonts.headerFont,
    color: AppColors.brown,
    shadows: [
      Shadow(offset: Offset(-_offset, -_offset), color: AppColors.gold),
      Shadow(offset: Offset(_offset, -_offset), color: AppColors.gold),
      Shadow(offset: Offset(_offset, _offset), color: AppColors.gold),
      Shadow(offset: Offset(-_offset, _offset), color: AppColors.gold),
    ],
  );

  // Section title base — the readable body font, bold. Section headings use
  // size/weight for hierarchy instead of the decorative font, per current
  // typography guidance (display fonts only for large headings).
  static const TextStyle _sectionTitleBase = TextStyle(
    fontFamily: AppFonts.bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.brown,
    letterSpacing: 0.2,
  );

  // Body text base
  static final TextStyle _bodyBase = const TextStyle(
    fontFamily: AppFonts.bodyFont,
    color: AppColors.brown,
  );

  // ============================================
  // DECORATIVE TITLES (with gold shadow)
  // ============================================

  static TextStyle loadingTextStyle = _titleBase.copyWith(fontSize: 54);
  static TextStyle titleTextStyle = _titleBase.copyWith(fontSize: 32);
  static TextStyle menuTitle = _titleBase.copyWith(fontSize: 54);

  // App bar: the readable body font, bold and letterspaced, rendered
  // uppercase by the scaffold. Chrome repeats on every screen, so it has to
  // stay crisp — the decorative font frayed here and long titles
  // ("CALCULADORA DE PUNTUACIÓ") were scaled down to illegible by the
  // FittedBox. The brand voice lives in the logo and the splash.
  static TextStyle appBarTextStyle = _sectionTitleBase.copyWith(
    fontSize: 19,
    letterSpacing: 2,
  );

  // Markdown H2 / HeaderWidget: readable body font, bold. (Was decorative.)
  static TextStyle markdownH2 = _sectionTitleBase.copyWith(
    fontSize: 18,
    letterSpacing: 0.3,
  );

  /// The plain counterpart of [titleTextStyle], for a screen's main heading
  /// when that heading is *data* rather than a brand moment — a tile's name,
  /// say. The decorative scale tops out at 32 and the plain one used to stop
  /// at 19, so anything in between had no token and reached for the
  /// decorative font by default.
  static TextStyle screenTitlePlain = _sectionTitleBase.copyWith(
    fontSize: 24,
    letterSpacing: 0.25,
  );

  // ============================================
  // SECTION TITLES
  // ============================================

  // Section headings: readable body font, bold. The gold-outline decorative
  // treatment was dropped here — it hurt legibility at these sizes.
  static TextStyle sectionTitle = _sectionTitleBase;
  static TextStyle sectionTitlePlain = _sectionTitleBase;

  // Tile-card boardgame title (rendered uppercased by the widget): body
  // font, bold, tight tracking — legible at small sizes over the card.
  static TextStyle boardgameTitle = _sectionTitleBase.copyWith(
    fontSize: 13,
    letterSpacing: 0.5,
  );

  // Card / sheet / primary-button titles at medium sizes: readable body font,
  // bold. The decorative font is reserved for the logo and display moments —
  // at ~18-20px it read as rough and hurt the product's finish.
  static TextStyle boardgameTitlePlain = _sectionTitleBase.copyWith(
    fontSize: 19,
    letterSpacing: 0.25,
  );

  // ============================================
  // MENU STYLES
  // ============================================

  // Drawer list items: readable body font, bold — a big legibility win over
  // the decorative font at list sizes.
  static TextStyle menuItem = const TextStyle(
    fontSize: 20,
    fontFamily: AppFonts.bodyFont,
    fontWeight: FontWeight.w700,
    color: AppColors.brown,
    letterSpacing: 0.3,
  );

  // ============================================
  // BODY TEXT
  // ============================================

  static TextStyle bodyMedium = _bodyBase;
  static TextStyle bodySmall = _bodyBase.copyWith(fontSize: 12);
  static TextStyle sectionSubtitle = bodySmall; // = bodySmall

  // Markdown styles
  static TextStyle markdownBold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.bodyFont,
    fontSize: 18,
  );
  static TextStyle markdownBody = const TextStyle(
    fontWeight: FontWeight.normal,
    fontFamily: AppFonts.bodyFont,
    fontSize: 18,
  );

  // ============================================
  // LABELS & SMALL TEXT
  // ============================================

  static TextStyle sectionSublabel = _bodyBase.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.brown.withValues(alpha: 0.7),
  );

  static TextStyle instruction = _bodyBase.copyWith(
    fontSize: 13,
    fontStyle: FontStyle.italic,
  );

  static TextStyle badge = _bodyBase.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );

  static TextStyle badgeCount = const TextStyle(
    fontFamily: AppFonts.bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.greenDarker,
  );

  /// Progress counters ("3/8"): always the readable body font with
  /// tabular figures — the decorative header font is for titles only.
  static TextStyle phaseCounter = const TextStyle(
    fontFamily: AppFonts.bodyFont,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColors.brown,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static TextStyle warningText = _bodyBase.copyWith(fontSize: 10);

  // ============================================
  // TILE STYLES
  // ============================================

  static TextStyle tileType = const TextStyle(
    fontSize: 12,
    fontFamily: AppFonts.bodyFont,
    fontWeight: FontWeight.w700,
    color: AppColors.badgeText,
  );

  static TextStyle tileName = const TextStyle(
    fontSize: 16,
    fontFamily: AppFonts.bodyFont,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tileBadge = const TextStyle(
    fontSize: 12,
    fontFamily: AppFonts.bodyFont,
    fontWeight: FontWeight.w500,
    color: AppColors.badgeTransparentText,
  );

  static TextStyle tileQuantity = const TextStyle(
    fontSize: 16,
    fontFamily: AppFonts.bodyFont,
    fontWeight: FontWeight.bold,
    color: AppColors.greenNormal,
    shadows: [
      Shadow(offset: Offset(0, 0), color: AppColors.black, blurRadius: 4),
      Shadow(offset: Offset(0, 0), color: AppColors.black, blurRadius: 4),
      Shadow(offset: Offset(0, 0), color: AppColors.black, blurRadius: 8),
      Shadow(offset: Offset(0, 0), color: AppColors.black, blurRadius: 8),
    ],
  );

  static TextStyle tileNameSmall = _bodyBase.copyWith(fontSize: 13);

  // ============================================
  // PLAYER STYLES
  // ============================================

  static TextStyle playerName = _bodyBase.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle circlePosition = const TextStyle(
    fontFamily: AppFonts.bodyFont,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.brown,
  );

  static TextStyle colorName = const TextStyle(
    fontFamily: AppFonts.bodyFont,
    fontSize: 11,
    color: AppColors.grey,
  );

  // ============================================
  // INPUT STYLES
  // ============================================

  static TextStyle hintText = _bodyBase.copyWith(fontSize: 11);
}
