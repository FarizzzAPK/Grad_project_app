import 'package:clincal/features/auth/widgets/custom_text_form_field.dart';
import 'package:clincal/features/auth/widgets/login_signup_button.dart';
import 'package:clincal/features/auth/widgets/login_with_google.dart';
import 'package:clincal/features/auth/widgets/or_row.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff101a31),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 150),
            Text(
              "Health portal",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(32),
              height: 500,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xff304369)),
                color: Color(0xff172133).withOpacity(0.7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 8),
                    child: Text(
                      "Username or Email",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  CustomTextFormField(
                    hintText: "Asmaa@gmail.com",
                    icon: Icon(Icons.email),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xff256af4).withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomTextFormField(
                    hintText: "********",
                    icon: Icon(Icons.lock),
                  ),
                  SizedBox(height: 32),
                  LoginSignupButton(text: "Log in"),
                  SizedBox(height: 16),
                  OrRow(),
                  SizedBox(height: 16),
                  LoginWithGoogle(),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "Don't have an account?.. ",
                  weight: FontWeight.w500,
                  color: Colors.white30,
                  size: 14,
                ),
                CustomText(
                  text: "Sign Up",
                  weight: FontWeight.w500,
                  color: Colors.blue,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
