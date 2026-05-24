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

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AppColors appColors = AppColors();

  @override
  void initState() {
    super.initState();
    ProfileController.instance.loadProfile();
  }

  Future<void> _handleRefresh() async {
    await ProfileController.instance.loadProfile(force: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: Colors.blueAccent,
          backgroundColor: const Color(0xff131B2E),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
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
                      // Reactively rebuilds when profileData changes
                      ValueListenableBuilder<PatientDataModel?>(
                        valueListenable: ProfileController.instance.profileData,
                        builder: (context, data, _) {
                          String name = "User Default";
                          String email = "Unknown Email";

                          if (data != null) {
                            if (data.data.userName.isNotEmpty) {
                              name = data.data.userName;
                            }
                            if (data.data.email.isNotEmpty) {
                              email = data.data.email;
                            }
                          }

                          // Show loading indicator when data is null and loading
                          return ValueListenableBuilder<bool>(
                            valueListenable: ProfileController.instance.isLoading,
                            builder: (context, loading, _) {
                              if (loading && data == null) {
                                name = "Loading...";
                                email = "Loading...";
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditUserData()),
                  ),
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
                    // Clear profile state
                    ProfileController.instance.clearProfile();

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
    ),
  );
}
}
