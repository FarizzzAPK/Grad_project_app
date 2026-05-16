

class MedicationResponse {
  final bool success;
  final String? message;
  final List<MedicationModel> data;

  MedicationResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory MedicationResponse.fromJson(Map<String, dynamic> json) =>
      MedicationResponse(
        success: json['success'] ?? false,
        message: json['message'],
        data: json['data'] != null
            ? List<MedicationModel>.from(
                json['data'].map((x) => MedicationModel.fromJson(x)),
              )
            : [],
      );
}

class MedicationModel {
  final int id;
  final String name;
  final String dosage;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final int status;
  final String? reviewNote;
  final DateTime createdAt;
  final List<String> reminderTimes;
  final List<int> daysOfWeek;
  final String? notes;
  final String source;
  final int? prescribedByDoctorId;
  final int? doctorRequestId;
  final DateTime updatedAt;

  MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.endDate,
    required this.status,
    this.reviewNote,
    required this.createdAt,
    required this.reminderTimes,
    required this.daysOfWeek,
    this.notes,
    required this.source,
    this.prescribedByDoctorId,
    this.doctorRequestId,
    required this.updatedAt,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) =>
      MedicationModel(
        id: json['id'],
        name: json['name'] ?? '',
        dosage: json['dosage'] ?? '',
        frequency: json['frequency'] ?? '',
        startDate: DateTime.parse(json['startDate']),
        endDate:
            json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
        status: json['status'] ?? 0,
        reviewNote: json['reviewNote'],
        createdAt: DateTime.parse(json['createdAt']),
        reminderTimes: json['reminderTimes'] != null
            ? List<String>.from(json['reminderTimes'])
            : [],
        daysOfWeek: json['daysOfWeek'] != null
            ? List<int>.from(json['daysOfWeek'])
            : [],
        notes: json['notes'],
        source: json['source'] ?? '',
        prescribedByDoctorId: json['prescribedByDoctorId'],
        doctorRequestId: json['doctorRequestId'],
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dosage': dosage,
        'frequency': frequency,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'status': status,
        'reviewNote': reviewNote,
        'createdAt': createdAt.toIso8601String(),
        'reminderTimes': reminderTimes,
        'daysOfWeek': daysOfWeek,
        'notes': notes,
        'source': source,
        'prescribedByDoctorId': prescribedByDoctorId,
        'doctorRequestId': doctorRequestId,
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Whether this medication was prescribed by a doctor
  bool get isDoctorPrescribed => source == 'DoctorPrescribed';

  /// Formatted reminder times (strips seconds if present)
  List<String> get formattedReminderTimes => reminderTimes.map((t) {
        // Handle both "09:00" and "09:00:00" formats
        final parts = t.split(':');
        if (parts.length >= 2) {
          return '${parts[0]}:${parts[1]}';
        }
        return t;
      }).toList();

  /// Human-readable day names
  String get daysOfWeekText {
    if (daysOfWeek.length == 7) return 'Every day';
    const dayNames = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return daysOfWeek.map((d) => d < dayNames.length ? dayNames[d] : '').join(', ');
  }

  /// Status text
  String get statusText {
    switch (status) {
      case 0:
        return 'Active';
      case 1:
        return 'Completed';
      case 2:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}
