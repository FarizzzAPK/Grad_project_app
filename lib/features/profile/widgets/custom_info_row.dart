import 'package:flutter/material.dart';
import 'package:clincal/shared/custom_text.dart';

class CustomInfoRow extends StatelessWidget {
  final String infoName;
  final String infoData;
  final IconData? icon;
  final Color nameColor;
  final Color dataColor;
  final bool isBoldData;

  const CustomInfoRow({
    super.key,
    required this.infoName,
    required this.infoData,
    this.icon,
    this.nameColor = const Color(0xff95a2b8),
    this.dataColor = Colors.white,
    this.isBoldData = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.blueAccent.withOpacity(0.8), size: 20),
              const SizedBox(width: 12),
            ],
            CustomText(
              text: infoName,
              color: nameColor,
              size: 15,
              weight: FontWeight.w500,
            ),
          ],
        ),
        CustomText(
          text: infoData,
          color: dataColor,
          size: 15,
          weight: isBoldData ? FontWeight.bold : FontWeight.w600,
        ),
      ],
    );
  }
}