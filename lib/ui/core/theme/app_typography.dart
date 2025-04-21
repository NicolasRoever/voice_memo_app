import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static final TextStyle mainHeading = GoogleFonts.notoSerif(
    fontSize: 35,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static final TextStyle heading = GoogleFonts.notoSerif(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static final TextStyle buttonText = GoogleFonts.notoSerif(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: CupertinoColors.white,
  );

  static const TextStyle subtitle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: CupertinoColors.systemGrey,

);
}
