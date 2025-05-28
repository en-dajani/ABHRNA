// create static class theme

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() {
    return FlexThemeData.light(
      scheme: FlexScheme.flutterDash,
      fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
    );
  }

  static ThemeData dark() {
    return FlexThemeData.dark(
      scheme: FlexScheme.bahamaBlue,
      fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
    );
  }
}
