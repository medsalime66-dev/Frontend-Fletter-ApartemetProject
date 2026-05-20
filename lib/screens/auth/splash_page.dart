import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

import '../auth/login_page.dart';

import '../home/home_page.dart';

import '../../widgets/owner/owner_home_page.dart';

import '../worker/worker_home_page.dart';

class SplashPage extends StatefulWidget{

  const SplashPage({super.key});

  @override
  State<SplashPage> createState()=>_SplashPageState();
}

class _SplashPageState extends State<SplashPage>{

  @override
  void initState(){

    super.initState();

    checkLogin();
  }

  ///check authentication
  Future<void> checkLogin() async{

    await Future.delayed(
      const Duration(seconds:2),
    );

    final isLoggedIn=
    await AuthService.isLoggedIn();

    if(!mounted){
      return;
    }

    if(!isLoggedIn){

      goToLogin();

      return;
    }

    final role=
    await AuthService.getRole();

    if(role==null){

      goToLogin();

      return;
    }

    ///owner
    if(role=='OWNER'){

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder:(_)=>const OwnerHomePage(),
        ),
      );

      return;
    }

    ///worker
    if(role=='WORKER'){

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder:(_)=>const WorkerHomePage(),
        ),
      );

      return;
    }

    ///client
    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder:(_)=>const HomePage(),
      ),
    );
  }

  ///go login
  void goToLogin(){

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder:(_)=>const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      body:Center(

        child:Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children:[

            Container(

              height:110,

              width:110,

              decoration:BoxDecoration(

                color:Colors.black,

                borderRadius:
                BorderRadius.circular(30),
              ),

              child:const Icon(

                Icons.apartment,

                size:55,

                color:Colors.white,
              ),
            ),

            const SizedBox(height:24),

            const Text(

              'SAKAN',

              style:TextStyle(

                fontSize:32,

                fontWeight:FontWeight.w900,
              ),
            ),

            const SizedBox(height:16),

            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}