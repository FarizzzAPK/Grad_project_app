import 'package:clincal/features/auth/widgets/custom_text_form_field.dart';
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
              style: TextStyle(color: Colors.white, fontSize: 25),
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
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xff256af4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        "Log In",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
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
                  ),
                  SizedBox(height: 16),
                  Container(
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
                          Image.asset(
                            "assets/images/googleLogo.png",
                            height: 25,
                          ),
                          SizedBox(width: 10,),
                          Text(
                            "Login with Google",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
