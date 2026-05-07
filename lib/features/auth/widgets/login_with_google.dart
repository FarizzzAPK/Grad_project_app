import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:clincal/features/auth/data/auth_service.dart';
import 'package:clincal/root.dart';

class LoginWithGoogle extends StatefulWidget {
  const LoginWithGoogle({super.key});

  @override
  State<LoginWithGoogle> createState() => _LoginWithGoogleState();
}

class _LoginWithGoogleState extends State<LoginWithGoogle> {
  bool _isLoading = false;

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await GoogleSignIn.instance.initialize(
        serverClientId:
            "991223563819-konvo9un3t424frsnhakbh9oiboo0h8n.apps.googleusercontent.com",
      );

      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception(
          "Verification failed: Google Identity Token was not generated natively. Check your Web Client ID.",
        );
      }
      await AuthService.instance.loginWithGoogle(idToken);

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Root()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (!e.toString().contains('canceled')) {
          print("NATIVE DIAGNOSTIC ERROR: $e");
          _showErrorDialog(
            "Authentication Failed",
            e.toString().replaceAll('Exception: ', ''),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        try {
          await GoogleSignIn.instance.signOut();
        } catch (_) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _handleGoogleSignIn,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff304369)),
          color: Color(0xff172133),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: _isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.blueAccent,
                    strokeWidth: 3,
                  ),
                )
              : Row(
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
