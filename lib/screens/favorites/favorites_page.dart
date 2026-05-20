import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class FavoritesPage extends StatelessWidget{

  const FavoritesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar:AppBar(

        title:const Text(
          'Favorites',
        ),
      ),

      body:const Center(

        child:Padding(

          padding:EdgeInsets.all(
            AppSpacing.screen,
          ),

          child:Text(

            'Favorites feature will be added later.',

            style:
            AppTextStyles.body,

            textAlign:
            TextAlign.center,
          ),
        ),
      ),
    );
  }
}