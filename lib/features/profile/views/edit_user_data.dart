import 'package:clincal/features/auth/data/auth_service.dart';
import 'package:clincal/features/auth/views/login_view.dart';
import 'package:clincal/features/profile/widgets/custom_container.dart';
import 'package:clincal/features/profile/widgets/custom_edit_button.dart';
import 'package:clincal/features/profile/widgets/profile_image.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class EditUserData extends StatelessWidget {
  const EditUserData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: CustomText(text: "Edit Your Info", color: Colors.white),
        centerTitle: true,
        backgroundColor: Color(0xff101a31),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileImage(),
            SizedBox(height: 32),
            CustomEditButton(text: "Change your Name"),
            SizedBox(height: 16),

            CustomEditButton(text: "Change your Email"),
            SizedBox(height: 16),
            CustomEditButton(text: "Change your gender"),

            SizedBox(height: 16),

            CustomEditButton(text: "Change your Password"),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                // Call AuthService to clear session locally
                await AuthService.instance.clearAuth();

                if (context.mounted) {
                  // Navigate back to Login Screen and clear routing stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                    (route) => false,
                  );
                }
              },
              child: CustomContainer(
                text: "Delete My Account",
                icon: Icons.restore_from_trash_outlined,
                bgColor: Colors.red,
                iconColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
