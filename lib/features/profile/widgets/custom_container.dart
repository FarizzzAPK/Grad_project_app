import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:clincal/shared/custom_text.dart';

class CustomContainer extends StatelessWidget {
  final String text;
  final double size;
  final Color bgColor;
  final FontWeight weight;
  final IconData icon;
  final double iconSize;
  final Color iconColor;

  const CustomContainer({
    super.key,
    required this.text,
    this.size = 16,
    this.bgColor = Colors.white,
    this.weight = FontWeight.w500,
    required this.icon,
    this.iconSize = 20,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: iconSize, color: iconColor),
                const SizedBox(width: 10),
                CustomText(
                  text: text,
                  size: size,
                  color: Colors.white,
                  weight: weight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
