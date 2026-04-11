import 'package:clincal/features/profile/widgets/custom_info_row.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 16),
          child: CustomText(
            text: "Personal Info",
            color: Color(0xffDAE2FD),
            size: 20,
            weight: FontWeight.bold,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xff18223C),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const CustomInfoRow(
                icon: Icons.badge_outlined,
                infoName: "User ID",
                infoData: "#13264",
              ),
              _buildDivider(),
              const CustomInfoRow(
                icon: Icons.phone_outlined,
                infoName: "Phone Number",
                infoData: "01154176265",
              ),
              _buildDivider(),
              const CustomInfoRow(
                icon: Icons.calendar_today_outlined,
                infoName: "Date of Birth",
                infoData: "01 / 01 / 2000",
              ),
              _buildDivider(),
              const CustomInfoRow(
                icon: Icons.water_drop_outlined,
                infoName: "Blood Type",
                infoData: "O Positive",
                dataColor: Color(0xffFF6B6B),
                isBoldData: true,
              ),
              _buildDivider(),
              const CustomInfoRow(
                icon: Icons.medical_services_outlined,
                infoName: "Personal Doctor",
                infoData: "Dr. Bahaa Shams",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(color: Colors.white.withOpacity(0.05), height: 1),
    );
  }
}

