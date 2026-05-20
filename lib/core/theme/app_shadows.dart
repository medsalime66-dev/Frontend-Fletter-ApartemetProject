import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppShadows{

  AppShadows._();

  static const List<BoxShadow> soft=[
    BoxShadow(
      color:AppColors.shadow,
      blurRadius:24,
      offset:Offset(0,12),
    ),
  ];

  static const List<BoxShadow> medium=[
    BoxShadow(
      color:AppColors.shadow,
      blurRadius:16,
      offset:Offset(0,8),
    ),
  ];
}