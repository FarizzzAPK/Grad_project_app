import 'package:flutter/material.dart';
import 'package:clincal/shared/custom_text.dart';

class CustomAlertCard extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const CustomAlertCard({
    super.key,
    required this.text,
    this.color = const Color(0xffFF6B6B),
    this.icon = Icons.warning_amber_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 10),
          Expanded(
            child: CustomText(
              text: text,
              color: Colors.white,
              size: 14,
              weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}