import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class LoginSignupButton extends StatelessWidget {
  const LoginSignupButton({super.key, required this.text, this.onTap});
  final String text;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xff256af4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: CustomText(text: text, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
