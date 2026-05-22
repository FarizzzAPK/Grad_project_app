import 'package:clincal/core/constants/app_colors.dart';
import 'package:clincal/features/medication/data/medication_controller.dart';
import 'package:clincal/features/medication/data/medication_model.dart';
import 'package:clincal/shared/custom_text.dart';
import 'package:flutter/material.dart';

class AddMedicationView extends StatefulWidget {
  final MedicationController controller;
  final MedicationModel? medicationToEdit;
  
  const AddMedicationView({super.key, required this.controller, this.medicationToEdit});

  @override
  State<AddMedicationView> createState() => _AddMedicationViewState();
}

class _AddMedicationViewState extends State<AddMedicationView> {
  final AppColors appColors = AppColors();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  
  // For Days of Week: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun
  final List<int> _selectedDays = [];
  final List<String> _daysOfWeekNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  final List<TimeOfDay> _reminderTimes = [];

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.medicationToEdit != null) {
      final med = widget.medicationToEdit!;
      _nameController.text = med.name;
      _dosageController.text = med.dosage;
      _frequencyController.text = med.frequency.toString();
      _notesController.text = med.notes ?? '';
      _startDate = med.startDate;
      _endDate = med.endDate;
      _selectedDays.addAll(med.daysOfWeek);
      
      for (final timeStr in med.formattedReminderTimes) {
        final parts = timeStr.split(':');
        if (parts.length >= 2) {
          final h = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          if (h != null && m != null) {
            _reminderTimes.add(TimeOfDay(hour: h, minute: m));
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ───────────────────────── UI Helpers ─────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Icon(icon, color: Colors.blueAccent.withOpacity(0.8)),
          filled: true,
          fillColor: const Color(0xff131B2E),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xff131B2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.blueAccent.withOpacity(0.8), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  date != null ? "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}" : label,
                  style: TextStyle(
                    color: date != null ? Colors.white : Colors.white.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────── Actions ─────────────────────────

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? (_startDate ?? DateTime.now())),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Color(0xff18223C),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Color(0xff18223C),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _reminderTimes.add(picked);
      });
    }
  }

  Future<void> _saveMedication() async {
    if (_nameController.text.trim().isEmpty) {
      _showError("Please enter medication name");
      return;
    }
    if (_startDate == null || _endDate == null) {
      _showError("Please select start and end dates");
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final List<String> formattedTimes = _reminderTimes.map((t) {
      final h = t.hour.toString().padLeft(2, '0');
      final m = t.minute.toString().padLeft(2, '0');
      return "$h:$m:00"; // backend usually expects HH:mm:ss for times
    }).toList();

    final List<String> days = _selectedDays.map((d) => d.toString()).toList();

    bool success;
    if (widget.medicationToEdit != null) {
      success = await widget.controller.editMedication(
        id: widget.medicationToEdit!.id,
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        frequency: _frequencyController.text.trim(),
        startDate: _startDate!.toUtc().toIso8601String(),
        endDate: _endDate!.toUtc().toIso8601String(),
        reminderTimes: formattedTimes.isEmpty ? null : formattedTimes,
        daysOfWeek: days.isEmpty ? null : days,
        notes: _notesController.text.trim(),
      );
    } else {
      success = await widget.controller.addMedication(
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        frequency: _frequencyController.text.trim(),
        startDate: _startDate!.toUtc().toIso8601String(),
        endDate: _endDate!.toUtc().toIso8601String(),
        reminderTimes: formattedTimes.isEmpty ? null : formattedTimes,
        daysOfWeek: days.isEmpty ? null : days,
        notes: _notesController.text.trim(),
      );
    }

    if (mounted) {
      setState(() {
        _isSaving = false;
      });
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.medicationToEdit != null ? 'Medication updated successfully!' : 'Medication added successfully!'),
            backgroundColor: Colors.green
          ),
        );
        Navigator.pop(context);
      } else {
        _showError(widget.controller.errorMessage ?? "Failed to save medication");
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  // ───────────────────────── Build ─────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const CustomText(text: "Add Medication", color: Colors.white),
        centerTitle: true,
        backgroundColor: const Color(0xff101a31),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Details section
            const CustomText(text: "Medication Details", size: 18, color: Color(0xffDAE2FD), weight: FontWeight.bold),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nameController,
              label: "Medication Name",
              icon: Icons.medication_outlined,
            ),
            _buildTextField(
              controller: _dosageController,
              label: "Dosage (e.g. 1 pill, 500mg)",
              icon: Icons.vaccines_outlined,
            ),
            _buildTextField(
              controller: _frequencyController,
              label: "Frequency (e.g. 1)",
              icon: Icons.repeat_outlined,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),
            const CustomText(text: "Schedule", size: 18, color: Color(0xffDAE2FD), weight: FontWeight.bold),
            const SizedBox(height: 16),
            
            // Dates
            Row(
              children: [
                _buildDatePicker(label: "Start Date", date: _startDate, onTap: () => _pickDate(true)),
                const SizedBox(width: 12),
                _buildDatePicker(label: "End Date", date: _endDate, onTap: () => _pickDate(false)),
              ],
            ),
            
            const SizedBox(height: 24),
            // Days of week
            const CustomText(text: "Days of Week", size: 16, color: Colors.white70),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(7, (index) {
                final dayNum = index + 1; // 1 to 7
                final isSelected = _selectedDays.contains(dayNum);
                return ChoiceChip(
                  label: Text(_daysOfWeekNames[index], style: TextStyle(color: isSelected ? Colors.white : Colors.white70)),
                  selected: isSelected,
                  selectedColor: Colors.blueAccent,
                  backgroundColor: const Color(0xff131B2E),
                  checkmarkColor: Colors.white,
                  side: BorderSide(color: isSelected ? Colors.blueAccent : Colors.white.withOpacity(0.1)),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedDays.add(dayNum);
                      } else {
                        _selectedDays.remove(dayNum);
                      }
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 24),
            // Reminder Times
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(text: "Reminder Times", size: 16, color: Colors.white70),
                TextButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.add_alarm, color: Colors.blueAccent),
                  label: const Text("Add Time", style: TextStyle(color: Colors.blueAccent)),
                ),
              ],
            ),
            if (_reminderTimes.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xff131B2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _reminderTimes.map((time) {
                    return Chip(
                      label: Text(time.format(context), style: const TextStyle(color: Colors.white)),
                      backgroundColor: const Color(0xff18223C),
                      deleteIconColor: Colors.redAccent,
                      onDeleted: () {
                        setState(() {
                          _reminderTimes.remove(time);
                        });
                      },
                      side: BorderSide.none,
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 24),
            const CustomText(text: "Additional Info", size: 18, color: Color(0xffDAE2FD), weight: FontWeight.bold),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _notesController,
              label: "Notes",
              icon: Icons.note_alt_outlined,
              maxLines: 3,
            ),
            
            const SizedBox(height: 32),
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveMedication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isSaving
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : const Text(
                        "Save Medication",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
