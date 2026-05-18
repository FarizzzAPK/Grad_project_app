
import 'package:clincal/features/profile/controllers/profile_controller.dart';
import 'package:clincal/features/profile/patient_data_model.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Good Morning",
                    size: 12,
                    color: Color(0xff95a2b8),
                  ),
                  ValueListenableBuilder<PatientDataModel?>(
                    valueListenable: ProfileController.instance.profileData,
                    builder: (context, data, _) {
                      String userName = "Loading...";
                      if (data != null && data.data.userName.isNotEmpty) {
                        userName = data.data.userName;
                      }
                      return CustomText(
                        text: "Welcome, $userName",
                        size: 15,
                        color: Colors.white,
                      );
                    },
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
            width: 60,
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
    );
  }
}
