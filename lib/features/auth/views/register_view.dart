import 'package:clincal/features/auth/widgets/go_to_login.dart';
import 'package:clincal/features/auth/widgets/logo_widget.dart';
import 'package:clincal/features/auth/widgets/register_container.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
              SizedBox(height: 40),
              LogoWidget(),
              SizedBox(height: 16),
              RegisterContainer(),
              SizedBox(height: 16),
              GoToLogin(),
            ],
          ),
        ),
      ),
    );
  }
}
