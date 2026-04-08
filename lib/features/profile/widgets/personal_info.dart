import 'package:clincal/features/profile/widgets/custom_info_row.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

import 'profile_image.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      height: 300,
      width: double.infinity,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [

          CustomInfoRow(infoName: "personal Info", infoData: "", nameSize: 20),
          CustomInfoRow(
            infoName: "Date of Birth",
            infoData: "1/1/2000",
            nameSize: 16,
            nameColor: Color(0xffC5C6CD),
          ),
          CustomInfoRow(
            infoName: "Blood Type",
            infoData: "O Positive",
            nameSize: 16,
            nameColor: Color(0xffC5C6CD),
            dataColor: Color(0xffFFB4AB),
          ),
          CustomInfoRow(
            infoName: "Primary Language",
            infoData: "English",
            nameSize: 16,
            nameColor: Color(0xffC5C6CD),
          ),
        ],
      ),
    );
  }
}
