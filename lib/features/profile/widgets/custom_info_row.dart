import 'package:flutter/material.dart';
import 'package:clincal/shared/custom_text.dart';

class CustomInfoRow extends StatelessWidget {
  const CustomInfoRow({
    super.key,
    required this.infoName,
    required this.infoData,
    this.nameColor = const Color(0xffB9C7E4),
    this.dataColor = const Color(0xffDAE2FD),
    this.nameSize = 16,
  });

  final String infoName;
  final String infoData;
  final Color nameColor;
  final Color dataColor;
  final double nameSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: infoName,
          color: nameColor,
          size: nameSize,
        ),
        CustomText(
          text: infoData,
          color: dataColor,
          size: 13,
        ),
      ],
    );
  }
}