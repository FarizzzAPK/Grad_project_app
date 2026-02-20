import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
   ProfileView({super.key});
AppColors appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,

      body: Center(child: CustomText(text: "profile")),
    );
  }
}
