import 'package:clincal/features/auth/data/auth_service.dart';
import 'package:clincal/features/auth/data/models/user_model.dart';
import 'package:clincal/features/auth/widgets/custom_text_form_field.dart';
import 'package:clincal/features/auth/widgets/login_signup_button.dart';
import 'package:clincal/features/auth/widgets/login_with_google.dart';
import 'package:clincal/features/auth/widgets/or_row.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class RegisterContainer extends StatefulWidget {
  const RegisterContainer({super.key});

  @override
  State<RegisterContainer> createState() => _RegisterContainerState();
}

class _RegisterContainerState extends State<RegisterContainer> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                text: "Full Name",
                color: Colors.white,
                size: 12,
              ),
            ),
            CustomTextFormField(
              controller: _nameController,
              hintText: "Farizzz",
              icon: const Icon(Icons.person),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: CustomText(
                text: "Email",
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
            const Padding(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: CustomText(
                text: "Password",
                color: Colors.white,
                size: 12,
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
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: CustomText(
                text: "Confirm Password",
                color: Colors.white,
                size: 12,
              ),
            ),
            CustomTextFormField(
              controller: _confirmPasswordController,
              hintText: "********",
              icon: const Icon(Icons.lock_outline),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            LoginSignupButton(
              text: "Sign Up",
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Processing Registration...'),
                    ),
                  );

                  try {
                    final newUser = UserModel(
                      username: _nameController.text,
                      email: _emailController.text,
                      phoneNumber: "",
                      password: _passwordController.text,
                      confirmPassword: _confirmPasswordController.text,
                      isDoctor: false,
                    );

                    await AuthService.instance.register(newUser.toJson());

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration Successful! Please Log in.'), 
                          backgroundColor: Colors.green
                        ),
                      );
                      // Go back to login screen
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                      );
                    }
                  }
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
