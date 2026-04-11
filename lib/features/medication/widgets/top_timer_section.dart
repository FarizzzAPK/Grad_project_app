import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopTimerSection extends StatelessWidget {
  const TopTimerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A47),
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A4B8C), Color(0xFF162544)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.timer_outlined, color: Colors.white70, size: 32),
          const SizedBox(height: 12),
          const CustomText(
            text: 'Next Dose In',
            color: Colors.white70,
            size: 16,
            weight: FontWeight.w500,
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CustomText(
                text: '02',
                color: Colors.white,
                size: 48,
                weight: FontWeight.bold,
              ),
              CustomText(
                text: 'H',
                color: Colors.white70,
                size: 20,
                weight: FontWeight.w500,
              ),
              SizedBox(width: 12),
              CustomText(
                text: '45',
                color: Colors.white,
                size: 48,
                weight: FontWeight.bold,
              ),
              CustomText(
                text: 'M',
                color: Colors.white70,
                size: 20,
                weight: FontWeight.w500,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withOpacity(0.5),
                        blurRadius: 6,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const CustomText(
                  text: 'Amoxicillin 500mg',
                  color: Colors.white,
                  size: 15,
                  weight: FontWeight.w600,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
