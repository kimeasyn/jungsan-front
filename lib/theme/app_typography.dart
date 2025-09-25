import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Font Family
  static const String fontFamily = 'Noto Sans KR';
  
  // Font Sizes
  static const double fontSizeH1 = 24.0;
  static const double fontSizeH2 = 20.0;
  static const double fontSizeH3 = 18.0;
  static const double fontSizeH4 = 16.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeCaption = 12.0;
  static const double fontSizeSmall = 10.0;
  
  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  
  // Text Styles
  static TextStyle get h1 => GoogleFonts.notoSans(
    fontSize: fontSizeH1,
    fontWeight: fontWeightBold,
    height: 1.2,
  );
  
  static TextStyle get h2 => GoogleFonts.notoSans(
    fontSize: fontSizeH2,
    fontWeight: fontWeightSemiBold,
    height: 1.3,
  );
  
  static TextStyle get h3 => GoogleFonts.notoSans(
    fontSize: fontSizeH3,
    fontWeight: fontWeightSemiBold,
    height: 1.3,
  );
  
  static TextStyle get h4 => GoogleFonts.notoSans(
    fontSize: fontSizeH4,
    fontWeight: fontWeightMedium,
    height: 1.4,
  );
  
  static TextStyle get bodyLarge => GoogleFonts.notoSans(
    fontSize: fontSizeBody + 2,
    fontWeight: fontWeightRegular,
    height: 1.5,
  );
  
  static TextStyle get body => GoogleFonts.notoSans(
    fontSize: fontSizeBody,
    fontWeight: fontWeightRegular,
    height: 1.5,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.notoSans(
    fontSize: fontSizeBody,
    fontWeight: fontWeightMedium,
    height: 1.5,
  );
  
  static TextStyle get caption => GoogleFonts.notoSans(
    fontSize: fontSizeCaption,
    fontWeight: fontWeightRegular,
    height: 1.4,
  );
  
  static TextStyle get captionMedium => GoogleFonts.notoSans(
    fontSize: fontSizeCaption,
    fontWeight: fontWeightMedium,
    height: 1.4,
  );
  
  static TextStyle get small => GoogleFonts.notoSans(
    fontSize: fontSizeSmall,
    fontWeight: fontWeightRegular,
    height: 1.3,
  );
  
  // Button Text Styles
  static TextStyle get buttonLarge => GoogleFonts.notoSans(
    fontSize: fontSizeBody + 2,
    fontWeight: fontWeightSemiBold,
    height: 1.2,
  );
  
  static TextStyle get button => GoogleFonts.notoSans(
    fontSize: fontSizeBody,
    fontWeight: fontWeightMedium,
    height: 1.2,
  );
  
  static TextStyle get buttonSmall => GoogleFonts.notoSans(
    fontSize: fontSizeCaption,
    fontWeight: fontWeightMedium,
    height: 1.2,
  );
}
