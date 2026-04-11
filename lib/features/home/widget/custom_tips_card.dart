import 'package:flutter/material.dart';
import 'package:clincal/shared/custom_text.dart';

class CustomTipsCard extends StatelessWidget {
  final List<String> tips;
  final String title;
  final Color color;
  final IconData icon;

  const CustomTipsCard({
    super.key,
    required this.tips,
    this.title = "Important Tips",
    this.color = const Color(0xff4E9F3D),
    this.icon = Icons.health_and_safety,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color,size: 25,),
              SizedBox(width: 8),
              CustomText(
                text: title,
                color: Colors.white,
                size: 18,
                weight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: 10),

          ...tips.map(
                (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: CustomText(
                text: "• $tip",
                color: Colors.white70,
                size: 16,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}