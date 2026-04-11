import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/home/widget/custom_request_card.dart';
import 'package:clincal/features/requests/widgets/custom_tab.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:clincal/shared/no_requests.dart';
import 'package:flutter/material.dart';

class RequestsView extends StatelessWidget {
  RequestsView({super.key});
  final AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    bool isThereRequests = true;
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Medical Requests",
                    color: Color(0xffDAE2FD),
                    size: 22,
                    weight: FontWeight.w600,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E293B),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.tune_rounded,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const CustomText(
                text: "Manage your\nclinical priorities",
                color: Colors.white,
                size: 32,
                weight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              const CustomTab(),
              const SizedBox(height: 20),
              Expanded(
                child: isThereRequests
                    ? ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: 5,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return Center(
                            child: Container(
                              child: const CustomRequestCard(),
                              width: double.infinity,
                            ),
                          );
                        },
                      )
                    : const NoRequests(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
