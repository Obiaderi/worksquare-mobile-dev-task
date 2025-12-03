import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:worksquare_housing/core/core.dart';

class AppTypography {
  static final Color _defaultColor = AppColor.black.withValues(alpha: 0.83);

  // Font size definitions
  static TextStyle text8 = _createTextStyle(fontSize: 8);
  static TextStyle text10 = _createTextStyle(fontSize: 10);
  static TextStyle text12 = _createTextStyle(fontSize: 12);
  static TextStyle text13 = _createTextStyle(fontSize: 13);
  static TextStyle text14 = _createTextStyle(fontSize: 14);
  static TextStyle text15 = _createTextStyle(fontSize: 15);
  static TextStyle text16 = _createTextStyle(fontSize: 16);
  static TextStyle text18 = _createTextStyle(fontSize: 18);
  static TextStyle text20 = _createTextStyle(fontSize: 20);
  static TextStyle text22 = _createTextStyle(fontSize: 22);
  static TextStyle text24 = _createTextStyle(fontSize: 24);
  static TextStyle text26 = _createTextStyle(fontSize: 26);
  static TextStyle text28 = _createTextStyle(fontSize: 28);
  static TextStyle text30 = _createTextStyle(fontSize: 30);
  static TextStyle text32 = _createTextStyle(fontSize: 32);
  static TextStyle text36 = _createTextStyle(fontSize: 36);
  static TextStyle text48 = _createTextStyle(fontSize: 48);

  // Variation methods using the utility method
  static TextStyle withBold(TextStyle baseStyle) {
    return _recreateStyle(baseStyle, fontWeight: FontWeight.bold);
  }

  static TextStyle withMedium(TextStyle baseStyle) {
    return _recreateStyle(baseStyle, fontWeight: FontWeight.w500);
  }

  static TextStyle withColor(TextStyle baseStyle, Color color) {
    return _recreateStyle(baseStyle, color: color);
  }

  static TextStyle withHeight(TextStyle baseStyle, double height) {
    return _recreateStyle(baseStyle, height: height);
  }

  static TextStyle _createTextStyle({required double fontSize}) {
    return TextStyle(fontSize: fontSize.sp, color: _defaultColor);
  }

  static TextStyle _recreateStyle(
    TextStyle baseStyle, {
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return baseStyle.copyWith(
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }
}

// Usage examples:
// Basic usage: AppTypography.text16
// With modification: AppTypography.withBold(AppTypography.text16)
// With color: AppTypography.withColor(AppTypography.text16, AppColor.brandBlue)
// Chained modifications:
// AppTypography.withColor(AppTypography.withBold(AppTypography.text16), AppColors.primary)

// Shorthand extension methods for more fluent usage
extension TextStyleExtensions on TextStyle {
  TextStyle get bold => AppTypography.withBold(this);
  TextStyle get medium => AppTypography.withMedium(this);
  TextStyle withCustomColor(Color color) =>
      AppTypography.withColor(this, color);
  TextStyle withCustomHeight(double height) =>
      AppTypography.withHeight(this, height);
}

// Usage with extensions:
// Text('Hello', style: AppTypography.text16.bold)
// Text('Hello', style: AppTypography.text16.withCustomColor(AppColor.brandBlue))
// Text('Hello', style: AppTypography.text16.bold.withCustomColor(AppColor.brandBlue))
