import 'package:clincal/features/auth/views/register_view.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class GoToSighup extends StatelessWidget {
  const GoToSighup({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(
          text: "Don't have an account?.. ",
          weight: FontWeight.w500,
          color: Colors.white30,
          size: 14,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegisterView()),
            );
          },
          child: const CustomText(
            text: "Sign Up",
            weight: FontWeight.w500,
            color: Colors.blue,
            size: 16,
          ),
        ),
      ],
    );
  }
}
