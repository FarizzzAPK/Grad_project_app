import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class MedicationCard extends StatelessWidget {
  final Map<String, dynamic> medication;

  const MedicationCard({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final bool isNearest = medication['isNearest'] ?? false;
    final Color brandColor = medication['color'] ?? Colors.blueAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF18223C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNearest
              ? Colors.blueAccent.withOpacity(0.6)
              : Colors.white.withOpacity(0.05),
          width: 1.5,
        ),
        boxShadow: isNearest
            ? [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
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
                      child: Icon(medication['icon'], color: brandColor, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: medication['name'] ?? '',
                            color: Colors.white,
                            size: 18,
                            weight: FontWeight.bold,
                          ),
                          const SizedBox(height: 6),
                          CustomText(
                            text: medication['dosage'] ?? '',
                            color: Colors.white54,
                            size: 14,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    if (isNearest)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const CustomText(
                          text: 'Next',
                          color: Colors.blueAccent,
                          size: 12,
                          weight: FontWeight.bold,
                        ),
                      )
                    else
                      const Icon(Icons.more_vert, color: Colors.white30, size: 20),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.white10, height: 1),
                ),
                _buildInfoRow(Icons.access_time_rounded, medication['schedule'] ?? ''),
                const SizedBox(height: 10),
                _buildInfoRow(
                    Icons.person_outline_rounded, 'Prescribed by ${medication['doctor']}'),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.date_range_rounded, medication['duration'] ?? ''),
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
}

