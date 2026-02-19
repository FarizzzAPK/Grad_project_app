import 'package:clincal/features/auth/widgets/custom_text_form_field.dart';
import 'package:clincal/features/auth/widgets/login_signup_button.dart';
import 'package:clincal/features/auth/widgets/login_with_google.dart';
import 'package:clincal/features/auth/widgets/or_row.dart';
import 'package:clincal/features/home/views/home_view.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class LoginContainer extends StatefulWidget {
   LoginContainer({super.key});

  @override
  State<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return               Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xff304369)),
        color: const Color(0xff172133).withOpacity(0.7),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: CustomText(
                text: "Username or Email",
                color: Colors.white,
                size: 12,
              ),
            ),
            CustomTextFormField(
              controller: _emailController,
              hintText: "Farizzz256@gmail.com",
              icon: const Icon(Icons.email),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Password",
                    color: Colors.white,
                    size: 12,
                  ),
                  CustomText(
                    text: "Forgot Password?",
                    color: const Color(0xff256af4).withOpacity(0.7),
                    size: 12,
                  ),
                ],
              ),
            ),
            CustomTextFormField(
              controller: _passwordController,
              hintText: "********",
              icon: const Icon(Icons.lock),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            LoginSignupButton(
              text: "Log in",
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // Proceed with login
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeView(),));
                }
              },
            ),
            const SizedBox(height: 16),
            const OrRow(),
            const SizedBox(height: 16),
            const LoginWithGoogle(),
          ],
        ),
      ),
    )
    ;
  }
}
