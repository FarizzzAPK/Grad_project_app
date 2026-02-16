import 'package:flutter/material.dart';

class OrRow extends StatelessWidget {
  const OrRow({super.key});

  @override
  Widget build(BuildContext context) {
    return                   Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,

      children: [
        SizedBox(
          height: 1,
          width: 100,
          child: ColoredBox(color: Colors.white30),
        ),
        Text(
          "Or",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        SizedBox(
          height: 1,
          width: 100,
          child: ColoredBox(color: Colors.white30),
        ),
      ],
    )
    ;
  }
}
