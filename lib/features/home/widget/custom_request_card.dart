import 'package:clincal/features/requests/models/patient_request_model.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CustomRequestCard extends StatelessWidget {
  final PatientRequest request;

  const CustomRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF18223C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff222A3D),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    height: 40,
                    width: 50,
                    child: Icon(
                      _getSubjectIcon(request.subject),
                      color: Color(0xffcad5e0),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: request.subject,
                        size: 15,
                        color: Color(0xffDAE2FD),
                        weight: FontWeight.w600,
                      ),
                      CustomText(
                        text: "Doctor #${request.doctorId}",
                        size: 12,
                        color: Color(0xffC5C6CD),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: request.importanceColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                height: 35,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: CustomText(
                    text: request.importance,
                    color: request.importanceTextColor,
                    size: 13,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          CustomText(
            overflow: TextOverflow.ellipsis,
            text: request.messagePreview,
            color: Color(0xffC5C6CD),
            size: 14,
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, color: Color(0xffC5C6CD), size: 14),
                  SizedBox(width: 4),
                  CustomText(
                    text: request.formattedDate,
                    color: Color(0xffC5C6CD),
                    size: 12,
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.reply_rounded, color: Color(0xffC5C6CD), size: 16),
                  SizedBox(width: 4),
                  CustomText(
                    text: "${request.responseCount} responses",
                    color: Color(0xffC5C6CD),
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'food':
        return Icons.restaurant_outlined;
      case 'medication':
        return Icons.medication_outlined;
      case 'surgery':
        return Icons.healing_sharp;
      case 'checkup':
        return Icons.health_and_safety_outlined;
      case 'lab':
        return Icons.science_outlined;
      default:
        return Icons.medical_services_outlined;
    }
  }
}