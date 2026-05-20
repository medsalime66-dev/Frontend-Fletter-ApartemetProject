import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/network/api_client.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

import '../../services/auth_service.dart';

import '../../widgets/apartment/apartment_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_skeleton.dart';

import '../auth/login_page.dart';
import '../detail/detail_page.dart';

class WorkerHomePage extends StatefulWidget{

  const WorkerHomePage({
    super.key,
  });

  @override
  State<WorkerHomePage> createState()=>
      _WorkerHomePageState();
}

class _WorkerHomePageState
    extends State<WorkerHomePage>{

  final Dio dio=
      ApiClient.dio;

  List<ApartmentModel> apartments=[];

  bool isLoading=true;

  @override
  void initState(){

    super.initState();

    loadPendingApartments();
  }

  ///load pending apartments
  Future<void>
  loadPendingApartments()async{

    try{

      setState((){
        isLoading=true;
      });

      final response=
      await dio.get(
        '/api/apartments',
      );

      final data=
      response.data as List;

      final result=

      data.map((json){

        return ApartmentModel
            .fromJson(json);

      }).where((apartment){

        return apartment.status
            .toUpperCase()=='PENDING';

      }).toList();

      if(!mounted){
        return;
      }

      setState((){

        apartments=result;

        isLoading=false;
      });

    }catch(e){

      if(!mounted){
        return;
      }

      setState((){
        isLoading=false;
      });
    }
  }

  ///approve apartment
  Future<void> approveApartment(
      int apartmentId,
      )async{

    try{

      await dio.put(
        '/api/apartments/$apartmentId/approve',
      );

      apartments.removeWhere(
            (apartment){

          return apartment.id==
              apartmentId;
        },
      );

      if(!mounted){
        return;
      }

      setState((){});

    }catch(e){}
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
          'Worker Dashboard',
        ),

        actions:[

          IconButton(

            onPressed:
            loadPendingApartments,

            icon:const Icon(
              Icons.refresh,
            ),
          ),

          IconButton(

            onPressed:logout,

            icon:const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),

      body:isLoading

          ?const LoadingSkeleton()

          :apartments.isEmpty

          ?const EmptyState(
        text:
        'No pending apartments',
      )

          :RefreshIndicator(

        onRefresh:
        loadPendingApartments,

        child:ListView(

          padding:
          const EdgeInsets.all(
            AppSpacing.screen,
          ),

          children:[

            const Text(
              'Pending Apartments',
              style:
              AppTextStyles.h1,
            ),

            const SizedBox(height:24),

            ...apartments.map(

                  (apartment){

                return Column(

                  children:[

                    ApartmentCard(

                      apartment:
                      apartment,

                      showApproveButton:true,

                      onApprove:(){

                        approveApartment(
                          apartment.id,
                        );
                      },

                      onTap:(){

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder:(_)=>
                                DetailPage(
                                  apartment:
                                  apartment,
                                ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height:24),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}