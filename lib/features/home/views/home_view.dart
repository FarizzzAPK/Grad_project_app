import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/home/widget/app_bar.dart';
import 'package:clincal/features/home/widget/custom_alert_card.dart';
import 'package:clincal/features/home/widget/custom_doctor_card.dart';
import 'package:clincal/features/home/widget/custom_request_card.dart';
import 'package:clincal/features/home/widget/custom_tips_card.dart';
import 'package:clincal/features/home/widget/search_field.dart';
import 'package:clincal/features/requests/controllers/requests_controller.dart';
import 'package:clincal/features/requests/models/patient_request_model.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final AppColors appColors = AppColors();
  final RequestsController _requestsController = RequestsController();

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
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
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
                FutureBuilder<List<PatientRequest>>(
                  future: _requestsController.fetchPatientRequests(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 120,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        ),
                      );
                    }

                    final requests = snapshot.data ?? [];

                    if (requests.isEmpty) {
                      return const SizedBox(
                        height: 80,
                        child: Center(
                          child: CustomText(
                            text: "No requests yet",
                            color: Color(0xffC5C6CD),
                          ),
                        ),
                      );
                    }

                    // Single request — center it at full width
                    if (requests.length == 1) {
                      return Center(
                        child: CustomRequestCard(request: requests.first),
                      );
                    }

                    // Multiple requests — horizontal scroll
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      clipBehavior: Clip.none,
                      child: Row(
                        children: requests.map((request) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: SizedBox(
                              width: 320,
                              child: CustomRequestCard(request: request),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
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
                const SizedBox(
                  height: 40,
                ), // Extra bottom padding for comfortable scroll
              ],
            ),
          ),
        ),
      ),
    );
  }
}
