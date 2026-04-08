import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/home/widget/app_bar.dart';
import 'package:clincal/features/home/widget/custom_doctor_card.dart';
import 'package:clincal/features/home/widget/custom_request_card.dart';
import 'package:clincal/features/home/widget/search_field.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  AppColors appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAppBar(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              height: 1,
              color: Color(0xff95a2b8).withOpacity(0.5),
            ),
            SearchField(),
            SizedBox(height: 32,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "Latest Requests",color: Color(0xffDAE2FD),size: 20,weight: FontWeight.bold,),
                CustomText(text: "View All",color: Color(0xffDAE2FD),size: 14,weight: FontWeight.w500,),
              ],
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomRequestCard(),
                    CustomRequestCard(),
                    CustomRequestCard(),
                    CustomRequestCard(),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
