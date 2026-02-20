import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/home/widget/search_field.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  AppColors appColors = AppColors();
  String name = "John";
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
            SizedBox(height: 16),
            Container(

              height: 60,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xff1e293b),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 60,
                        width: 60,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.person_outline,
                            color: Color(0xffcad5e0),
                            size: 28,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Good Morning",
                            size: 12,
                            color: Color(0xff95a2b8),
                          ),
                          CustomText(
                            text: "Welcome, $name",
                            size: 15,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff1e293b),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    height: 60,
                    width: 50,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notification_add,
                        color: Color(0xffcad5e0),
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              height: 1,
              color: Color(0xff95a2b8).withOpacity(0.5),
            ),
            SearchField(),
          ],
        ),
      ),
    );
  }
}
