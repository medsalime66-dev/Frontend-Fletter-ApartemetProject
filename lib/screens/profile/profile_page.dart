import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../services/auth_service.dart';

import '../auth/login_page.dart';

class ProfilePage extends StatefulWidget{

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState()=>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage>{

  String name='';
  String phone='';
  String role='';

  @override
  void initState(){

    super.initState();

    loadUser();
  }

  ///load user
  Future<void> loadUser()async{

    final loadedName=
    await AuthService.getName();

    final loadedPhone=
    await AuthService.getPhone();

    final loadedRole=
    await AuthService.getRole();

    setState((){

      name=loadedName??'';
      phone=loadedPhone??'';
      role=loadedRole??'';
    });
  }

  ///logout
  Future<void> logout()async{

    await AuthService.logout();

    if(!mounted){
      return;
    }

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(
        builder:(_)=>const LoginPage(),
      ),

          (route)=>false,
    );
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar:AppBar(
        title:const Text(
          'Profil',
        ),
      ),

      body:Padding(

        padding:
        const EdgeInsets.all(
          AppSpacing.screen,
        ),

        child:Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children:[

            Text(
              name,
              style:
              AppTextStyles.h1,
            ),

            const SizedBox(height:12),

            Text(
              phone,
              style:
              AppTextStyles.body,
            ),

            const SizedBox(height:12),

            Text(
              role,
              style:
              AppTextStyles.muted,
            ),

            const Spacer(),

            SizedBox(

              width:double.infinity,

              child:ElevatedButton(

                onPressed:logout,

                child:const Text(
                  'Logout',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}