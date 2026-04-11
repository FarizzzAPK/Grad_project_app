import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/home/widget/app_bar.dart';
import 'package:clincal/features/home/widget/custom_alert_card.dart';
import 'package:clincal/features/home/widget/custom_doctor_card.dart';
import 'package:clincal/features/home/widget/custom_request_card.dart';
import 'package:clincal/features/home/widget/custom_tips_card.dart';
import 'package:clincal/features/home/widget/search_field.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  width: double.infinity,
                  height: 1,
                  color: const Color(0xff95a2b8).withOpacity(0.2),
                ),
                SearchField(),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Latest Requests",
                      color: Color(0xffDAE2FD),
                      size: 20,
                      weight: FontWeight.bold,
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: CustomText(
                          text: "View All",
                          color: Colors.blueAccent,
                          size: 14,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      const CustomRequestCard(),
                      const SizedBox(width: 16),
                      const CustomRequestCard(),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                const CustomText(
                  text: "Health Alerts",
                  color: Color(0xffDAE2FD),
                  size: 20,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                const CustomAlertCard(
                  text:
                      "If you have persistent abdominal pain or bleeding, consult a doctor immediately.",
                ),
                const SizedBox(height: 32),
                const CustomText(
                  text: "Daily Wellness",
                  color: Color(0xffDAE2FD),
                  size: 20,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                const CustomTipsCard(
                  tips: [
                    "Drink plenty of water 💧",
                    "Eat fiber-rich foods (vegetables & fruits) 🥦",
                    "Avoid smoking 🚭",
                    "Do regular screenings 🧪",
                  ],
                ),
                const SizedBox(height: 40), // Extra bottom padding for comfortable scroll
              ],
            ),
          ),
        ),
      ),
    );
  }
}

