import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/home/widget/custom_request_card.dart';
import 'package:clincal/features/requests/widgets/custom_tab.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:clincal/shared/no_requests.dart';
import 'package:flutter/material.dart';

class RequestsView extends StatelessWidget {
  RequestsView({super.key});
  AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    bool isThereRequests=true;
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Medical Requests",
              color: Color(0xffB9C7E4),
              size: 22,
            ),
            SizedBox(height: 32),
            CustomText(
              text: "Manage your\nclinical priorities",
              color: Color(0xffB9C7E4),
              size: 28,
              weight: FontWeight.bold,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CustomTab(),
            ),
            Expanded(
                child: isThereRequests ?  ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      width: double.infinity,
                      child: CustomRequestCard()),) : NoRequests(),
            )

          ],
        ),
      ),
    );
  }
}
