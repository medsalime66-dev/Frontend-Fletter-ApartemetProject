import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

import '../../repositories/apartment_repository.dart';

import '../../widgets/apartment/apartment_card.dart';
import '../../widgets/common/section_title.dart';

import '../detail/detail_page.dart';
import '../profile/profile_page.dart';
import '../search/search_page.dart';

class HomePage extends StatefulWidget{

  const HomePage({super.key});

  @override
  State<HomePage> createState(){
    return _HomePageState();
  }
}

class _HomePageState
    extends State<HomePage>{

//repository
  final ApartmentRepository _repository=
  ApartmentRepository();

//apartments
  List<ApartmentModel> apartments=[];

//loading
  bool isLoading=true;

//selected nav index
  int selectedIndex=0;

  @override
  void initState(){

    super.initState();

    loadApartments();
  }

//load apartments
  Future<void> loadApartments()async{

    try{

      final result=
      await _repository
          .getApprovedApartments();

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

  @override
  Widget build(BuildContext context){

    final pages=[

      _HomeContent(
        apartments:apartments,
      ),

      SearchPage(
        apartments:apartments,
      ),

      const ProfilePage(),
    ];

    return Scaffold(

      body:isLoading

          ?const Center(
        child:CircularProgressIndicator(),
      )

          :pages[selectedIndex],

      bottomNavigationBar:
      NavigationBar(

        selectedIndex:selectedIndex,

        backgroundColor:
        AppColors.surface,

        indicatorColor:
        AppColors.primary
            .withOpacity(.15),

        onDestinationSelected:(value){

          setState((){

            selectedIndex=value;

          });
        },

        destinations:const[

          NavigationDestination(

            icon:Icon(
              Icons.home_outlined,
            ),

            selectedIcon:
            Icon(Icons.home),

            label:'Home',
          ),

          NavigationDestination(

            icon:Icon(
              Icons.search,
            ),

            selectedIcon:
            Icon(Icons.search),

            label:'Search',
          ),

          NavigationDestination(

            icon:Icon(
              Icons.person_outline,
            ),

            selectedIcon:
            Icon(Icons.person),

            label:'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeContent
    extends StatelessWidget{

  final List<ApartmentModel> apartments;

  const _HomeContent({
    required this.apartments,
  });

  @override
  Widget build(BuildContext context){

    return SafeArea(

      child:RefreshIndicator(

        onRefresh:()async{

          Navigator.pushReplacement(

            context,

            MaterialPageRoute(

              builder:(_)=>const HomePage(),
            ),
          );
        },

        child:ListView(

          padding:const EdgeInsets.all(
            AppSpacing.screen,
          ),

          children:[

//header
            Row(

              children:[

                const Expanded(

                  child:Text(

                    'SAKAN 🏠\nFind your next stay',

                    style:
                    AppTextStyles.h1,
                  ),
                ),

                IconButton.filledTonal(

                  onPressed:(){},

                  icon:const Icon(
                    Icons.notifications_none,
                  ),
                ),
              ],
            ),

            const SizedBox(height:24),

//search box
            GestureDetector(

              onTap:(){

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder:(_)=>SearchPage(
                      apartments:apartments,
                    ),
                  ),
                );
              },

              child:Container(

                padding:
                const EdgeInsets.symmetric(
                  horizontal:16,
                  vertical:15,
                ),

                decoration:BoxDecoration(

                  color:AppColors.surface,

                  borderRadius:
                  BorderRadius.circular(22),

                  border:Border.all(
                    color:AppColors.border,
                  ),
                ),

                child:const Row(

                  children:[

                    Icon(
                      Icons.search,
                      color:AppColors.muted,
                    ),

                    SizedBox(width:10),

                    Text(

                      'Search city or district',

                      style:TextStyle(
                        color:AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height:26),

//section title
            const SectionTitle(

              title:'Available Apartments',

              actionText:'Refresh',
            ),

            const SizedBox(height:14),

//empty state
            if(apartments.isEmpty)

              const Padding(

                padding:EdgeInsets.all(40),

                child:Center(

                  child:Text(
                    'No apartments found',
                  ),
                ),
              ),

//apartments
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

            }).toList(),
          ],
        ),
      ),
    );
  }
}