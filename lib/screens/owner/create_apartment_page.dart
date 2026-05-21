import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/network/api_client.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../repositories/apartment_repository.dart';

import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/primary_button.dart';

class CreateApartmentPage extends StatefulWidget{

  const CreateApartmentPage({
    super.key,
  });

  @override
  State<CreateApartmentPage> createState()=>
      _CreateApartmentPageState();
}

class _CreateApartmentPageState
    extends State<CreateApartmentPage>{

  final repository=
  ApartmentRepository();

  final titleController=
  TextEditingController();

  final descriptionController=
  TextEditingController();

  final cityController=
  TextEditingController();

  final districtController=
  TextEditingController();

  final priceController=
  TextEditingController();

  final walletController=
  TextEditingController();

  final roomsController=
  TextEditingController();

  final bathroomsController=
  TextEditingController();

  final areaController=
  TextEditingController();

  final picker=
  ImagePicker();

  bool isLoading=false;

  List<File> images=[];

  ///pick images
  Future<void> pickImages()async{

    final picked=
    await picker.pickMultiImage();

    if(picked.isEmpty){
      return;
    }

    setState((){

      images=
          picked.map((x){
            return File(x.path);
          }).toList();
    });
  }

  ///upload image
  Future<String> uploadImage(
      File image,
      )async{

    final formData=
    FormData.fromMap({

      'file':

      await MultipartFile.fromFile(
        image.path,
      ),
    });

    final response=
    await ApiClient.dio.post(
      '/upload',
      data:formData,
    );

    return response
        .data['fileUrl'];
  }

  ///create apartment
  Future<void> createApartment()async{

    if(images.isEmpty){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:Text(
            'Select at least one image',
          ),
        ),
      );

      return;
    }

    setState((){
      isLoading=true;
    });

    try{

      final imageUrls=
      <String>[];

      ///upload all images
      for(final image in images){

        final url=
        await uploadImage(image);

        imageUrls.add(url);
      }

      ///create apartment
      await repository
          .createApartment(

        title:
        titleController.text.trim(),

        description:
        descriptionController.text.trim(),

        city:
        cityController.text.trim(),

        district:
        districtController.text.trim(),

        pricePerNight:
        double.parse(
          priceController.text.trim(),
        ),

        walletCode:
        walletController.text.trim(),

        rooms:
        int.parse(
          roomsController.text.trim(),
        ),

        bathrooms:
        int.parse(
          bathroomsController.text.trim(),
        ),

        area:
        double.parse(
          areaController.text.trim(),
        ),

        imageUrls:imageUrls,
      );

      if(!mounted){
        return;
      }

      Navigator.pop(context,true);

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:Text(
            'Apartment created successfully',
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

    return Scaffold(

      appBar:AppBar(

        title:const Text(
          'Create Apartment',
        ),
      ),

      body:SingleChildScrollView(

        padding:const EdgeInsets.all(
          AppSpacing.screen,
        ),

        child:Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children:[

            const Text(
              'New Apartment',
              style:AppTextStyles.h1,
            ),

            const SizedBox(height:24),

            //images
            GestureDetector(

              onTap:pickImages,

              child:Container(

                height:180,

                width:double.infinity,

                decoration:BoxDecoration(

                  color:AppColors.surface,

                  borderRadius:
                  BorderRadius.circular(24),

                  border:Border.all(
                    color:AppColors.border,
                  ),
                ),

                child:images.isEmpty

                    ?const Column(

                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children:[

                    Icon(
                      Icons.image_outlined,
                      size:50,
                    ),

                    SizedBox(height:12),

                    Text(
                      'Select Images',
                    ),
                  ],
                )

                    :ListView.builder(

                  scrollDirection:
                  Axis.horizontal,

                  itemCount:
                  images.length,

                  itemBuilder:
                      (_,index){

                    return Padding(

                      padding:
                      const EdgeInsets.all(8),

                      child:ClipRRect(

                        borderRadius:
                        BorderRadius.circular(18),

                        child:Image.file(

                          images[index],

                          width:160,

                          fit:BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height:24),

            AppTextField(
              controller:titleController,
              label:'Title',
              icon:Icons.home_outlined,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:
              descriptionController,
              label:'Description',
              icon:Icons.description_outlined,
              maxLines:4,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:cityController,
              label:'City',
              icon:Icons.location_city,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:
              districtController,
              label:'District',
              icon:Icons.map_outlined,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:priceController,
              label:'Price Per Night',
              icon:Icons.attach_money,
              isNumeric:true,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:walletController,
              label:'Wallet Code',
              icon:Icons.wallet,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:roomsController,
              label:'Rooms',
              icon:Icons.bed_outlined,
              isNumeric:true,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:
              bathroomsController,
              label:'Bathrooms',
              icon:Icons.bathtub_outlined,
              isNumeric:true,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:areaController,
              label:'Area',
              icon:Icons.square_foot,
              isNumeric:true,
            ),

            const SizedBox(height:30),

            PrimaryButton(

              text:isLoading
                  ?'Loading...'
                  :'Create Apartment',

              onPressed:
              isLoading
                  ?null
                  :createApartment,
            ),
          ],
        ),
      ),
    );
  }
}