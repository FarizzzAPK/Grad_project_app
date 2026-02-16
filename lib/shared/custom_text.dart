import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String text;
  Color color;
  double size;
  TextOverflow? overflow;
  FontWeight weight;
   CustomText({super.key,required this.text,required this.weight, this.overflow,required this.color,required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        overflow: overflow,
        fontWeight: weight,
      ),
    );
  }
}

