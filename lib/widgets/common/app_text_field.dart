import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget{

  final TextEditingController? controller;

  final String label;

  final IconData icon;

  final bool isPassword;

  final bool isPhone;

  final bool isNumeric;

  final int? maxLength;

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

      keyboardType:

      isPhone||isNumeric

          ?TextInputType.number

          :TextInputType.text,

      maxLength:maxLength,

      decoration:InputDecoration(

        labelText:label,

        prefixIcon:Icon(icon),
      ),
    );
  }
}