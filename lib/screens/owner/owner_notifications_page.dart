import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class OwnerNotificationsPage extends StatelessWidget{

  const OwnerNotificationsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar:AppBar(
        title:const Text(
          'Notifications',
        ),
      ),

      body:const Center(

        child:Padding(

          padding:
          EdgeInsets.all(
            AppSpacing.screen,
          ),

          child:Text(
            'Notification system will be connected to backend later.',
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