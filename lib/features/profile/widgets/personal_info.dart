import 'package:clincal/features/profile/widgets/custom_info_row.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:clincal/features/profile/controllers/profile_controller.dart';
import 'package:clincal/features/profile/patient_data_model.dart';
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
          child: FutureBuilder<PatientDataModel?>(
            future: ProfileController().fetchPatientProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              String userId = "#11111";
              String phone = "01*********";
              String gender = "Male";
              String bloodType = "N/A";
              String dateOfBirth = "N/A";
              String joinedDate = "01 / 01 / 2026";
              String email = "example@mail.com";
              
              if (snapshot.hasData && snapshot.data != null) {
                final patientData = snapshot.data!.data;
                userId = "#${patientData.userId}";
                phone = patientData.phoneNumber;
                gender = patientData.gender;
                bloodType = patientData.formattedBloodType;
                if (patientData.dateOfBirth != null) {
                  final dob = patientData.dateOfBirth!;
                  dateOfBirth = "${dob.day.toString().padLeft(2, '0')} / ${dob.month.toString().padLeft(2, '0')} / ${dob.year}";
                }
                DateTime d = patientData.createdAt;
                joinedDate = "${d.day.toString().padLeft(2, '0')} / ${d.month.toString().padLeft(2, '0')} / ${d.year}";
                email = patientData.email;
              }

              return Column(
                children: [
                  CustomInfoRow(
                    icon: Icons.badge_outlined,
                    infoName: "User ID",
                    infoData: userId,
                  ),
                  _buildDivider(),
                  CustomInfoRow(
                    icon: Icons.phone_outlined,
                    infoName: "Phone Number",
                    infoData: phone,
                  ),
                  _buildDivider(),
                  CustomInfoRow(
                    icon: Icons.person_outline,
                    infoName: "Gender",
                    infoData: gender,
                  ),
                  _buildDivider(),
                  CustomInfoRow(
                    icon: Icons.bloodtype_outlined,
                    infoName: "Blood Type",
                    infoData: bloodType,
                  ),
                  _buildDivider(),
                  CustomInfoRow(
                    icon: Icons.cake_outlined,
                    infoName: "Date of Birth",
                    infoData: dateOfBirth,
                  ),
                  _buildDivider(),
                  CustomInfoRow(
                    icon: Icons.email_outlined,
                    infoName: "Email",
                    infoData: email,
                  ),
                  _buildDivider(),
                  CustomInfoRow(
                    icon: Icons.calendar_today_outlined,
                    infoName: "Joined Date",
                    infoData: joinedDate,
                  ),
                ],
              );
            },
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

