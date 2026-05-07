import 'package:clincal/features/auth/widgets/custom_text_form_field.dart';
import 'package:clincal/features/auth/widgets/go_to_sighup.dart';
import 'package:clincal/features/auth/widgets/login_container.dart';
import 'package:clincal/features/auth/widgets/login_signup_button.dart';
import 'package:clincal/features/auth/widgets/login_with_google.dart';
import 'package:clincal/features/auth/widgets/logo_widget.dart';

import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xff101a31),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 130,
              ),
              LogoWidget(),
              SizedBox(
                height: 16,
              ),
              LoginContainer(),
              SizedBox(
                height: 16,
              ),
              GoToSighup()
            ],
          ),
        ),
      ),
    );
  }
}
