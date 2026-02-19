import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final TextOverflow? overflow;
  final FontWeight? weight;

  const CustomText({
    super.key,
    required this.text,
    this.weight,
    this.overflow,
    this.color,
    this.size,
  });

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
