import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

class AppTheme {
  static CupertinoThemeData get light => CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: const CupertinoTextThemeData(
          textStyle: TextStyle(
            color: AppColors.text,
            fontSize: 16,
          ),
          actionTextStyle: TextStyle(
            color: AppColors.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}
