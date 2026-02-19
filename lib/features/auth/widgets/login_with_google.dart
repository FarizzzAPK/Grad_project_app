import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff304369)),
          color: Color(0xff172133),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/googleLogo.png", height: 25),
              SizedBox(width: 10),
              CustomText(
                text: "Login with Google",
                color: Colors.white,
                size: 13,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
