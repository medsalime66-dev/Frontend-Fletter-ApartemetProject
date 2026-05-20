import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme{

  AppTheme._();

  static ThemeData get light{

    return ThemeData(

      useMaterial3:true,

      scaffoldBackgroundColor:
      AppColors.background,

      primaryColor:
      AppColors.primary,

      appBarTheme:const AppBarTheme(

        backgroundColor:
        Colors.white,

        foregroundColor:
        Colors.black,

        elevation:0,
      ),

      colorScheme:
      ColorScheme.fromSeed(
        seedColor:
        AppColors.primary,
      ),

      inputDecorationTheme:
      InputDecorationTheme(

        filled:true,

        fillColor:Colors.white,

        border:OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(18),

          borderSide:BorderSide.none,
        ),
      ),

      elevatedButtonTheme:
      ElevatedButtonThemeData(

        style:ElevatedButton.styleFrom(

          backgroundColor:
          AppColors.primary,

          foregroundColor:
          Colors.white,

          padding:
          const EdgeInsets.symmetric(
            vertical:16,
          ),

          shape:RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}