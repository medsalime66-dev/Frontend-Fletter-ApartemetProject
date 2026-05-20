import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../services/auth_service.dart';

import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/primary_button.dart';

import '../home/home_page.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState()=>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage>{

  final formKey=
  GlobalKey<FormState>();

  final nameController=
  TextEditingController();

  final phoneController=
  TextEditingController();

  final passwordController=
  TextEditingController();

  bool isLoading=false;

  @override
  void dispose(){

    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  ///register
  Future<void> register()async{

    if(!formKey.currentState!
        .validate()){
      return;
    }

    setState((){
      isLoading=true;
    });

    try{

      final success=
      await AuthService.register(
        name:nameController.text.trim(),
        phone:phoneController.text.trim(),
        password:
        passwordController.text.trim(),
      );

      if(!mounted){
        return;
      }

      if(!success){

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content:Text(
              'Register failed',
            ),
          ),
        );

        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:(_)=>const HomePage(),
        ),
      );

    }catch(e){

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:Text(
            e.toString(),
          ),
        ),
      );

    }finally{

      if(mounted){

        setState((){
          isLoading=false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar:AppBar(),

      body:SafeArea(

        child:Padding(

          padding:
          const EdgeInsets.all(
            AppSpacing.screen,
          ),

          child:Form(

            key:formKey,

            child:Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children:[

                const Text(
                  'Créer un compte',
                  style:
                  AppTextStyles.h1,
                ),

                const SizedBox(height:8),

                const Text(
                  'Créez votre compte pour continuer.',
                  style:
                  AppTextStyles.muted,
                ),

                const SizedBox(height:30),

                AppTextField(
                  label:'Nom complet',
                  icon:
                  Icons.person_outline,
                  controller:
                  nameController,
                ),

                const SizedBox(height:14),

                AppTextField(
                  label:
                  'Numéro de téléphone',
                  icon:
                  Icons.phone_outlined,
                  isPhone:true,
                  controller:
                  phoneController,
                ),

                const SizedBox(height:14),

                AppTextField(
                  label:'Mot de passe',
                  icon:
                  Icons.lock_outline,
                  isPassword:true,
                  controller:
                  passwordController,
                ),

                const SizedBox(height:24),

                PrimaryButton(
                  text:isLoading
                      ?'Chargement...'
                      :'Créer',
                  onPressed:
                  isLoading
                      ?null
                      :register,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}