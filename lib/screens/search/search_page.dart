import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

import '../../widgets/apartment/apartment_card.dart';

import '../detail/detail_page.dart';

class SearchPage extends StatefulWidget{

  final List<ApartmentModel> apartments;

  const SearchPage({
    super.key,
    required this.apartments,
  });

  @override
  State<SearchPage> createState()=>
      _SearchPageState();
}

class _SearchPageState
    extends State<SearchPage>{

  final controller=
  TextEditingController();

  List<ApartmentModel> results=[];

  @override
  void initState(){

    super.initState();

    results=widget.apartments;
  }

  ///search apartments
  void search(String query){

    final lower=
    query.toLowerCase();

    setState((){

      results=
          widget.apartments.where(
                (apartment){

              return apartment.title
                  .toLowerCase()
                  .contains(lower)

                  ||

                  apartment.city
                      .toLowerCase()
                      .contains(lower)

                  ||

                  apartment.district
                      .toLowerCase()
                      .contains(lower)

                  ||

                  apartment.description
                      .toLowerCase()
                      .contains(lower);

            },
          ).toList();
    });
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar:AppBar(

        title:const Text(
          'Search Apartments',
        ),
      ),

      body:Padding(

        padding:const EdgeInsets.all(
          AppSpacing.screen,
        ),

        child:Column(

          children:[

//search field
            TextField(

              controller:controller,

              onChanged:search,

              decoration:InputDecoration(

                hintText:
                'City, district, title...',

                prefixIcon:
                const Icon(Icons.search),

                suffixIcon:
                controller.text.isNotEmpty

                    ?IconButton(

                  onPressed:(){

                    controller.clear();

                    search('');
                  },

                  icon:const Icon(
                    Icons.close,
                  ),
                )

                    :null,
              ),
            ),

            const SizedBox(height:24),

//results count
            Align(

              alignment:
              Alignment.centerLeft,

              child:Text(

                "${results.length} result(s)",

                style:
                AppTextStyles.muted,
              ),
            ),

            const SizedBox(height:16),

//results
            Expanded(

              child:

              results.isEmpty

                  ?const Center(

                child:Text(
                  'No apartments found',
                ),
              )

                  :ListView.builder(

                itemCount:
                results.length,

                itemBuilder:
                    (context,index){

                  final apartment=
                  results[index];

                  return ApartmentCard(

                    apartment:
                    apartment,

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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}