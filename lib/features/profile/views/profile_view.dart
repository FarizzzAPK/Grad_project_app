import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/auth/data/auth_service.dart';
import 'package:clincal/features/auth/views/login_view.dart';
import 'package:clincal/features/profile/views/edit_user_data.dart';
import 'package:clincal/features/profile/widgets/custom_container.dart';
import 'package:clincal/features/profile/widgets/personal_info.dart';
import 'package:clincal/features/profile/widgets/profile_image.dart';
import 'package:clincal/features/profile/controllers/profile_controller.dart';
import 'package:clincal/features/profile/patient_data_model.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});
  final AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "My Profile",
                      size: 26,
                      color: Color(0xffDAE2FD),
                      weight: FontWeight.bold,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.settings_outlined,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff131B2E),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const ProfileImage(),
                      const SizedBox(height: 20),
                      FutureBuilder<PatientDataModel?>(
                        future: ProfileController().fetchPatientProfile(),
                        builder: (context, snapshot) {
                          String name = "User Default";
                          String email = "Unknown Email";
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            name = "Loading...";
                            email = "Loading...";
                          } else if (snapshot.hasData && snapshot.data != null) {
                            if (snapshot.data!.data.userName.isNotEmpty) {
                              name = snapshot.data!.data.userName;
                            }
                            if (snapshot.data!.data.email.isNotEmpty) {
                              email = snapshot.data!.data.email;
                            }
                          }
                          return Column(
                            children: [
                              CustomText(
                                text: name,
                                size: 24,
                                color: Colors.white,
                                weight: FontWeight.bold,
                              ),
                              const SizedBox(height: 4),
                              CustomText(
                                text: email,
                                size: 14,
                                color: Colors.white54,
                                weight: FontWeight.w400,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const PersonalInfo(),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditUserData(),)),
                  child: CustomContainer(
                    text: "Edit My Info",
                    icon: Icons.key,
                    bgColor: Colors.green,
                    iconColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    // Call AuthService to clear session locally
                    await AuthService.instance.clearAuth();

                    if (context.mounted) {
                      // Navigate back to Login Screen and clear routing stack
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  child: CustomContainer(
                    text: "Logout",
                    icon: Icons.logout,
                    bgColor: Colors.red,
                    iconColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
