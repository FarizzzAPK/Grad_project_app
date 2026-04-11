import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class NoRequests extends StatelessWidget {
  const NoRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText(
        text: "There is no requests now",
        weight: FontWeight.bold,
        color: Color(0xffcad5e0),
      ),
    );
  }
}

