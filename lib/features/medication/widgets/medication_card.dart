import 'package:clincal/features/medication/data/medication_model.dart';
import 'package:clincal/features/medication/data/medication_controller.dart';
import 'package:clincal/features/medication/views/add_medication_view.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    Widget cardContent = AnimatedContainer(
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
          onLongPress: medication.isDoctorPrescribed
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Doctor prescribed medications cannot be edited."),
                      backgroundColor: Colors.orangeAccent,
                    ),
                  );
                }
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => AddMedicationView(
                        controller: Provider.of<MedicationController>(context, listen: false),
                        medicationToEdit: medication,
                      ),
                    ),
                  );
                },
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

    if (medication.isDoctorPrescribed) {
      return cardContent;
    }

    return Dismissible(
      key: ValueKey('med_${medication.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final messenger = ScaffoldMessenger.of(context);
        final controller = Provider.of<MedicationController>(context, listen: false);

        final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xff18223C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                SizedBox(width: 12),
                Text('Delete Medication', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              'Are you sure you want to delete ${medication.name}?\nThis action cannot be undone.',
              style: const TextStyle(color: Colors.white70, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Delete', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
        
        if (confirm == true) {
          final success = await controller.deleteMedication(medication.id);
          if (success) {
            messenger.showSnackBar(
              const SnackBar(content: Text('Medication deleted.'), backgroundColor: Colors.green),
            );
            return true;
          } else {
            messenger.showSnackBar(
              const SnackBar(content: Text('Failed to delete medication.'), backgroundColor: Colors.redAccent),
            );
            return false;
          }
        }
        return false;
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 32),
      ),
      child: cardContent,
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
