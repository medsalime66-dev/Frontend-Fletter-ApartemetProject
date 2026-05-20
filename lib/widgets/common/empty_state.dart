import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget{

  final String text;

  const EmptyState({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context){

    return Center(

      child:Padding(

        padding:
        const EdgeInsets.all(32),

        child:Text(
          text,
          textAlign:
          TextAlign.center,
        ),
      ),
    );
  }
}