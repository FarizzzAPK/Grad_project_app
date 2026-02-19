import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class OrRow extends StatelessWidget {
  const OrRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,

      children: [
        SizedBox(
          height: 1,
          width: 100,
          child: ColoredBox(color: Colors.white30),
        ),
        CustomText(text: "Or", size: 22, color: Colors.white),
        SizedBox(
          height: 1,
          width: 100,
          child: ColoredBox(color: Colors.white30),
        ),
      ],
    );
  }
}
