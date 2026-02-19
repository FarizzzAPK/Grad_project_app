import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 120,
        child: Image.asset("assets/images/gradlogo.png",));
  }
}
