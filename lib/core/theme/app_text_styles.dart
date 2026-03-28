import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  // ============================================
  // BASE STYLES
  // ============================================

  static const double _offset = 0.7;

  // Title base (for decorative titles with gold shadow)
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

  // Section title base (simple, no shadow)
  static const TextStyle _sectionTitleBase = TextStyle(
    fontFamily: AppFonts.headerFont,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.brown,
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
  static TextStyle appBarTextStyle = _titleBase.copyWith(fontSize: 36);
  static TextStyle titleTextStyle = _titleBase.copyWith(fontSize: 32);
  static TextStyle menuTitle = _titleBase.copyWith(fontSize: 54);
  static TextStyle markdownH2 = _titleBase.copyWith(fontSize: 20);

  // ============================================
  // SECTION TITLES
  // ============================================

  static TextStyle sectionTitle = _sectionTitleBase.copyWith(
    shadows: [
      Shadow(offset: Offset(-_offset, -_offset), color: AppColors.gold),
      Shadow(offset: Offset(_offset, -_offset), color: AppColors.gold),
      Shadow(offset: Offset(_offset, _offset), color: AppColors.gold),
      Shadow(offset: Offset(-_offset, _offset), color: AppColors.gold),
    ],
  );

  static TextStyle sectionTitlePlain = _sectionTitleBase;
  static TextStyle boardgameTitle = const TextStyle(
    color: AppColors.brown,
    fontSize: 18,
    fontFamily: AppFonts.headerFont,
    shadows: [
      Shadow(offset: Offset(-_offset, -_offset), color: AppColors.gold),
      Shadow(offset: Offset(_offset, -_offset), color: AppColors.gold),
      Shadow(offset: Offset(_offset, _offset), color: AppColors.gold),
      Shadow(offset: Offset(-_offset, _offset), color: AppColors.gold),
    ],
  );
  static TextStyle boardgameTitlePlain = const TextStyle(
    color: AppColors.brown,
    fontSize: 18,
    fontFamily: AppFonts.headerFont,
  );

  // ============================================
  // MENU STYLES
  // ============================================

  static TextStyle menuItem = const TextStyle(
    fontSize: 22,
    fontFamily: AppFonts.headerFont,
    color: AppColors.brown,
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
    color: Colors.grey,
  );

  // ============================================
  // INPUT STYLES
  // ============================================

  static TextStyle hintText = _bodyBase.copyWith(fontSize: 11);
}
