import 'package:flutter/material.dart';

import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';

import 'screens/auth/splash_page.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  ///initialize api client
  await ApiClient.init();

  runApp(
    const SakanApp(),
  );
}

class SakanApp extends StatelessWidget{

  const SakanApp({super.key});

  @override
  Widget build(BuildContext context){

    return MaterialApp(

      title:'Sakan',

      debugShowCheckedModeBanner:false,

      theme:AppTheme.light,

      home:const SplashPage(),
    );
  }
}