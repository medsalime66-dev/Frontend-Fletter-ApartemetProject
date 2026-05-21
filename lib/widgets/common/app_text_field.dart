import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppTextField extends StatelessWidget{

  final TextEditingController? controller;

  final String label;

  final IconData icon;

  final bool isPassword;

  final bool isPhone;

  final bool isNumeric;

  final int? maxLength;

  final int maxLines;

  final String? Function(String?)? validator;

  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    this.controller,
    required this.label,
    required this.icon,
    this.isPassword=false,
    this.isPhone=false,
    this.isNumeric=false,
    this.maxLength,
    this.maxLines=1,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context){

    return TextFormField(

      controller:controller,

      obscureText:isPassword,

      validator:validator,

      onChanged:onChanged,

      maxLength:maxLength,

      maxLines:maxLines,

      keyboardType:

      isPhone

          ?TextInputType.phone

          :isNumeric

          ?TextInputType.number

          :maxLines>1

          ?TextInputType.multiline

          :TextInputType.text,

      decoration:InputDecoration(

        labelText:label,

        alignLabelWithHint:
        maxLines>1,

        prefixIcon:maxLines>1

            ?Padding(

          padding:
          const EdgeInsets.only(
            bottom:70,
          ),

          child:Icon(icon),
        )

            :Icon(icon),

        filled:true,

        fillColor:Colors.white,

        border:OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(18),

          borderSide:BorderSide.none,
        ),

        enabledBorder:
        OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(18),

          borderSide:BorderSide(
            color:AppColors.border,
          ),
        ),

        focusedBorder:
        OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(18),

          borderSide:BorderSide(
            color:AppColors.primary,
            width:1.5,
          ),
        ),
      ),
    );
  }
}