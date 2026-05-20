import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class DateStatusLegend
    extends StatelessWidget{

  const DateStatusLegend({
    super.key,
  });

  @override
  Widget build(BuildContext context){

    return const Row(

      children:[

        _Item(
          color:AppColors.success,
          text:'Available',
        ),

        SizedBox(width:12),

        _Item(
          color:AppColors.warning,
          text:'Pending',
        ),

        SizedBox(width:12),

        _Item(
          color:AppColors.info,
          text:'Confirmed',
        ),
      ],
    );
  }
}

class _Item
    extends StatelessWidget{

  final Color color;

  final String text;

  const _Item({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context){

    return Row(

      children:[

        CircleAvatar(
          radius:5,
          backgroundColor:color,
        ),

        const SizedBox(width:5),

        Text(text),
      ],
    );
  }
}