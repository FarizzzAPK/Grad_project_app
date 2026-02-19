import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff101a31),body: Center(
      child: CustomText(
        text: "Welcome to Clinical",
        size: 22,
        color: Colors.white,
        weight: FontWeight.bold,
      ),
    ),

    );
  }
}
