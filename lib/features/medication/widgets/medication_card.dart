import 'package:clincal/features/medication/data/medication_model.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class MedicationCard extends StatelessWidget {
  final MedicationModel medication;
  final bool isHighlighted;

  const MedicationCard({
    super.key,
    required this.medication,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color brandColor = medication.isDoctorPrescribed
        ? Colors.orangeAccent
        : Colors.blueAccent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF18223C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlighted
              ? Colors.blueAccent.withOpacity(0.8)
              : Colors.white.withOpacity(0.05),
          width: isHighlighted ? 2.0 : 1.5,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.3),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.15),
                  blurRadius: 40,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          highlightColor: Colors.white.withOpacity(0.05),
          splashColor: Colors.white.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: brandColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        medication.isDoctorPrescribed
                            ? Icons.medical_services
                            : Icons.medication,
                        color: brandColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: medication.name,
                            color: Colors.white,
                            size: 18,
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(height: 6),
                          CustomText(
                            text: medication.dosage,
                            color: Colors.white54,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    // Source badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: medication.isDoctorPrescribed
                            ? Colors.orangeAccent.withOpacity(0.2)
                            : Colors.blueAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomText(
                        text: medication.isDoctorPrescribed
                            ? 'Prescribed'
                            : 'Self',
                        color: medication.isDoctorPrescribed
                            ? Colors.orangeAccent
                            : Colors.blueAccent,
                        size: 11,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.white10, height: 1),
                ),
                _buildInfoRow(
                  Icons.access_time_rounded,
                  medication.formattedReminderTimes.join(' - '),
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  Icons.repeat_rounded,
                  '${medication.frequency} • ${medication.daysOfWeekText}',
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  Icons.date_range_rounded,
                  medication.endDate != null
                      ? '${_formatDate(medication.startDate)} - ${_formatDate(medication.endDate!)}'
                      : '${_formatDate(medication.startDate)} - Ongoing',
                ),
                if (medication.notes != null &&
                    medication.notes!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.notes_rounded, medication.notes!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: CustomText(
            text: text,
            color: Colors.white70,
            size: 14,
            weight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month]} ${date.day}';
  }
}
