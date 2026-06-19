import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';

import '../../core/network/api_client.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

import '../../models/apartment_model.dart';
import '../../repositories/apartment_repository.dart';

import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/primary_button.dart';

class CreateApartmentPage extends StatefulWidget{

  final ApartmentModel? editApartment;

  const CreateApartmentPage({
    super.key,
    this.editApartment,
  });

  @override
  State<CreateApartmentPage> createState()=>
      _CreateApartmentPageState();
}

class _CreateApartmentPageState
    extends State<CreateApartmentPage>{

  final formKey=
  GlobalKey<FormState>();

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

  bool get isEditing=>
      widget.editApartment!=null;

  @override
  void initState(){
    super.initState();

    final apartment=
    widget.editApartment;

    if(apartment!=null){

      titleController.text=apartment.title;
      descriptionController.text=apartment.description;
      cityController.text=apartment.city;
      districtController.text=apartment.district;
      priceController.text='${apartment.pricePerNight}';
      walletController.text=apartment.walletCode;
      roomsController.text='${apartment.rooms}';
      bathroomsController.text='${apartment.bathrooms}';
      areaController.text='${apartment.area}';
    }
  }

  String? _requiredValidator(String? v){
    if(v==null||v.trim().isEmpty){
      return 'field_required'.tr;
    }
    return null;
  }

  String? _priceValidator(String? v){
    if(v==null||v.trim().isEmpty){
      return 'field_required'.tr;
    }
    final value=double.tryParse(v.trim());
    if(value==null){
      return 'invalid_number'.tr;
    }
    if(value<=0){
      return 'price_invalid'.tr;
    }
    return null;
  }

  String? _integerValidator(String? v){
    if(v==null||v.trim().isEmpty){
      return 'field_required'.tr;
    }
    if(int.tryParse(v.trim())==null){
      return 'invalid_number'.tr;
    }
    return null;
  }

  String? _numberValidator(String? v){
    if(v==null||v.trim().isEmpty){
      return 'field_required'.tr;
    }
    if(double.tryParse(v.trim())==null){
      return 'invalid_number'.tr;
    }
    return null;
  }

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

  ///create or update apartment
  Future<void> createApartment()async{

    if(!formKey.currentState!.validate()){
      return;
    }

    if(images.isEmpty&&!isEditing){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:Text(
            'select_image'.tr,
          ),
        ),
      );

      return;
    }

    setState((){
      isLoading=true;
    });

    try{

      ///upload new images, otherwise keep existing ones
      final imageUrls=
      images.isEmpty
          ?widget.editApartment!.imageUrls
          :<String>[];

      for(final image in images){

        final url=
        await uploadImage(image);

        imageUrls.add(url);
      }

      if(isEditing){

        ///update apartment
        await repository
            .updateApartment(

          id:widget.editApartment!.id,

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

      }else{

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
      }

      if(!mounted){
        return;
      }

      Navigator.pop(context,true);

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:Text(
            isEditing
                ?'Apartment updated successfully'
                :'Apartment created successfully',
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

        title:Text(
          isEditing
              ?'Edit Apartment'
              :'Create Apartment',
        ),
      ),

      body:SingleChildScrollView(

        padding:const EdgeInsets.all(
          AppSpacing.screen,
        ),

        child:Form(

          key:formKey,

          child:Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children:[

            Text(
              isEditing
                  ?'Edit Apartment'
                  :'New Apartment',
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
              validator:_requiredValidator,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:
              descriptionController,
              label:'Description',
              icon:Icons.description_outlined,
              maxLines:4,
              validator:_requiredValidator,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:cityController,
              label:'City',
              icon:Icons.location_city,
              validator:_requiredValidator,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:
              districtController,
              label:'District',
              icon:Icons.map_outlined,
              validator:_requiredValidator,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:priceController,
              label:'Price Per Night',
              icon:Icons.attach_money,
              isNumeric:true,
              validator:_priceValidator,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:walletController,
              label:'Wallet Code',
              icon:Icons.wallet,
              validator:_requiredValidator,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:roomsController,
              label:'Rooms',
              icon:Icons.bed_outlined,
              isNumeric:true,
              validator:_integerValidator,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:
              bathroomsController,
              label:'Bathrooms',
              icon:Icons.bathtub_outlined,
              isNumeric:true,
              validator:_integerValidator,
            ),

            const SizedBox(height:14),

            AppTextField(
              controller:areaController,
              label:'Area',
              icon:Icons.square_foot,
              isNumeric:true,
              validator:_numberValidator,
            ),

            const SizedBox(height:30),

            PrimaryButton(

              text:isLoading
                  ?'Loading...'
                  :isEditing
                      ?'Update Apartment'
                      :'Create Apartment',

              onPressed:
              isLoading
                  ?null
                  :createApartment,
            ),
          ],
        ),
        ),
      ),
    );
  }
}