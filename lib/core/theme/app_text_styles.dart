import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles{

  AppTextStyles._();

  static const TextStyle h1=TextStyle(
    fontSize:32,
    height:1.1,
    fontWeight:FontWeight.w900,
    color:AppColors.text,
  );

  static const TextStyle h2=TextStyle(
    fontSize:24,
    fontWeight:FontWeight.w800,
    color:AppColors.text,
  );

  static const TextStyle h3=TextStyle(
    fontSize:18,
    fontWeight:FontWeight.w700,
    color:AppColors.text,
  );

  static const TextStyle body=TextStyle(
    fontSize:15,
    height:1.5,
    color:AppColors.text,
  );

  static const TextStyle muted=TextStyle(
    fontSize:14,
    color:AppColors.muted,
  );

  static const TextStyle small=TextStyle(
    fontSize:12,
    fontWeight:FontWeight.w600,
    color:AppColors.muted,
  );
}