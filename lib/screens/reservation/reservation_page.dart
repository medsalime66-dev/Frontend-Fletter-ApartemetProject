import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';

import '../../services/reservation_service.dart';

import '../confirmation/confirmation_page.dart';

class ReservationPage extends StatefulWidget{

  final ApartmentModel apartment;

  const ReservationPage({
    super.key,
    required this.apartment,
  });

  @override
  State<ReservationPage> createState()=>
      _ReservationPageState();
}

class _ReservationPageState
    extends State<ReservationPage>{

  bool isLoading=false;

  ///confirm reservation
  Future<void> reserve()async{

    setState((){
      isLoading=true;
    });

    try{

      final success=
      await ReservationService
          .createReservation(
        apartmentId:
        widget.apartment.id,
      );

      if(!mounted){
        return;
      }

      if(success){

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder:(_)=>
            const ConfirmationPage(),
          ),
        );

        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:Text(
            'Reservation failed',
          ),
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

    final total=
        widget.apartment.pricePerNight;

    return Scaffold(

      appBar:AppBar(

        title:const Text(
          'Reservation',
        ),
      ),

      body:Padding(

        padding:const EdgeInsets.all(
          AppSpacing.screen,
        ),

        child:Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children:[

//title
            Text(
              widget.apartment.title,
              style:AppTextStyles.h1,
            ),

            const SizedBox(height:12),

//location
            Row(

              children:[

                const Icon(
                  Icons.location_on,
                  size:18,
                  color:AppColors.primary,
                ),

                const SizedBox(width:6),

                Expanded(

                  child:Text(

                    "${widget.apartment.city}, ${widget.apartment.district}",

                    style:
                    AppTextStyles.muted,
                  ),
                ),
              ],
            ),

            const SizedBox(height:28),

//summary
            Container(

              padding:
              const EdgeInsets.all(22),

              decoration:BoxDecoration(

                color:AppColors.surface,

                borderRadius:
                BorderRadius.circular(24),

                border:Border.all(
                  color:AppColors.border,
                ),
              ),

              child:Column(

                children:[

//price
                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children:[

                      const Text(
                        'Price Per Night',
                      ),

                      Text(

                        "${widget.apartment.pricePerNight} MRU",
                      ),
                    ],
                  ),

                  const SizedBox(height:18),

//wallet
                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children:[

                      const Text(
                        'Wallet',
                      ),

                      Text(
                        widget.apartment.walletCode,
                      ),
                    ],
                  ),

                  const SizedBox(height:18),

//total
                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children:[

                      const Text(

                        'Total',

                        style:TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      Text(

                        "$total MRU",

                        style:const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          fontSize:18,
                          color:
                          AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

//button
            SizedBox(

              width:double.infinity,

              height:56,

              child:ElevatedButton(

                onPressed:
                isLoading
                    ?null
                    :reserve,

                child:Text(

                  isLoading
                      ?'Loading...'
                      :'Confirm Reservation',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}