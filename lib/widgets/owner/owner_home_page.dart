import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

import '../../repositories/apartment_repository.dart';

import '../../services/auth_service.dart';

import '../../widgets/apartment/apartment_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_skeleton.dart';

import '../../screens/auth/login_page.dart';
import '../../screens/detail/detail_page.dart';
import '../../screens/owner/owner_notifications_page.dart';
import '../../screens/owner/owner_reservations_page.dart';

class OwnerHomePage extends StatefulWidget{

  const OwnerHomePage({
    super.key,
  });

  @override
  State<OwnerHomePage> createState()=>
      _OwnerHomePageState();
}

class _OwnerHomePageState
    extends State<OwnerHomePage>{

  final repository=
  ApartmentRepository();

  List<ApartmentModel> apartments=[];

  bool isLoading=true;

  @override
  void initState(){

    super.initState();

    loadApartments();
  }

  ///load apartments
  Future<void> loadApartments()async{

    try{

      final phone=
      await AuthService.getPhone();

      if(phone==null){

        setState((){
          isLoading=false;
        });

        return;
      }

      final result=
      await repository
          .getOwnerApartments(phone);

      setState((){

        apartments=result;

        isLoading=false;
      });

    }catch(e){

      setState((){
        isLoading=false;
      });
    }
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
          'Owner Dashboard',
        ),

        actions:[

          IconButton(

            onPressed:(){

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder:(_)=>
                  const OwnerReservationsPage(),
                ),
              );
            },

            icon:const Icon(
              Icons.calendar_month,
            ),
          ),

          IconButton(

            onPressed:(){

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder:(_)=>
                  const OwnerNotificationsPage(),
                ),
              );
            },

            icon:const Icon(
              Icons.notifications_none,
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
        text:'No apartments found',
      )

          :RefreshIndicator(

        onRefresh:loadApartments,

        child:ListView(

          padding:const EdgeInsets.all(
            AppSpacing.screen,
          ),

          children:[

            const Text(
              'My Apartments',
              style:AppTextStyles.h1,
            ),

            const SizedBox(height:24),

            ...apartments.map((apartment){

              return ApartmentCard(

                apartment:apartment,

                onTap:(){

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder:(_)=>DetailPage(
                        apartment:apartment,
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),

      floatingActionButton:
      FloatingActionButton.extended(

        backgroundColor:
        AppColors.primary,

        onPressed:(){},

        icon:const Icon(
          Icons.add,
        ),

        label:const Text(
          'Add Apartment',
        ),
      ),
    );
  }
}