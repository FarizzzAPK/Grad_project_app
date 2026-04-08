import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/profile/widgets/personal_info.dart';
import 'package:clincal/features/profile/widgets/profile_image.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});
  AppColors appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Profile Data",
              size: 28,
              color: Color(0xffDAE2FD),
              weight: FontWeight.bold,
            ),
            SizedBox(height: 16),
            Container(
              height: 600,
              decoration: BoxDecoration(
                color: Color(0xff131B2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xff233148)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 16),
                  Center(child: ProfileImage()),
                  SizedBox(height: 16),
                  CustomText(
                    text: "Sa7n elma3soub",
                    size: 28,
                    color: Color(0xffDAE2FD),
                    weight: FontWeight.bold,
                  ),
                  CustomText(
                    text: "ma3soub_mn_frm7@clinic.com",
                    size: 14,
                    color: Color(0xffC5C6CD),
                  ),
                  PersonalInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
