import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/profile/widgets/personal_info.dart';
import 'package:clincal/features/profile/widgets/profile_image.dart';
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
                        icon: const Icon(Icons.settings_outlined, color: Colors.blueAccent),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xff131B2E),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
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
                      const CustomText(
                        text: "Sa7n elma3soub",
                        size: 24,
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      const CustomText(
                        text: "ma3soub_mn_frm7@clinic.com",
                        size: 14,
                        color: Colors.white54,
                        weight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const PersonalInfo(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

