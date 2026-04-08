import 'package:flutter/material.dart';

class CustomDoctorCard extends StatelessWidget {
  const CustomDoctorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8.0 ),
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white
        ),
      ),
    );
  }
}
