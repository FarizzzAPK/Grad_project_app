import 'package:clincal/features/auth/views/login_view.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class GoToLogin extends StatelessWidget {
  const GoToLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText(
          text: "Already have an account? ",
          weight: FontWeight.w500,
          color: Colors.white30,
          size: 14,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          },
          child: const CustomText(
            text: "Log In",
            weight: FontWeight.w500,
            color: Colors.blue,
            size: 16,
          ),
        ),
      ],
    );
  }
}
