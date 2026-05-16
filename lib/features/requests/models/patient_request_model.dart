import 'dart:convert';
import 'dart:ui';

PatientRequestResponse patientRequestResponseFromJson(String str) =>
    PatientRequestResponse.fromJson(json.decode(str));

class PatientRequestResponse {
  PatientRequestResponse({
    required this.success,
    this.message,
    required this.data,
  });

  bool success;
  String? message;
  List<PatientRequest> data;

  factory PatientRequestResponse.fromJson(Map<dynamic, dynamic> json) =>
      PatientRequestResponse(
        success: json["success"] ?? false,
        message: json["message"],
        data: json["data"] != null
            ? List<PatientRequest>.from(
                json["data"].map((x) => PatientRequest.fromJson(x)))
            : [],
      );
}

class PatientRequest {
  PatientRequest({
    required this.id,
    required this.subject,
    required this.messagePreview,
    required this.importance,
    required this.doctorId,
    required this.responseCount,
    required this.createdAt,
  });

  int id;
  String subject;
  String messagePreview;
  String importance;
  String doctorId;
  int responseCount;
  DateTime createdAt;

  factory PatientRequest.fromJson(Map<dynamic, dynamic> json) => PatientRequest(
    id: json["id"] ?? 0,
    subject: json["subject"] ?? '',
    messagePreview: json["messagePreview"] ?? '',
    importance: json["importance"] ?? 'Low',
    doctorId: json["doctorId"] ?? '',
    responseCount: json["responseCount"] ?? 0,
    createdAt: DateTime.parse(json["createdAt"]),
  );

  /// Returns the color associated with the importance level
  Color get importanceColor {
    switch (importance.toLowerCase()) {
      case 'high':
        return const Color(0xff93000A);
      case 'medium':
        return const Color(0xffB86E00);
      case 'low':
      default:
        return const Color(0xff1B6B3A);
    }
  }

  /// Returns the text color for the importance badge
  Color get importanceTextColor {
    switch (importance.toLowerCase()) {
      case 'high':
        return const Color(0xffFFDAD6);
      case 'medium':
        return const Color(0xffFFE0B2);
      case 'low':
      default:
        return const Color(0xffC8E6C9);
    }
  }

  /// Returns a formatted date string
  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inDays == 0) {
      final hour = createdAt.hour > 12 ? createdAt.hour - 12 : createdAt.hour;
      final period = createdAt.hour >= 12 ? 'PM' : 'AM';
      final minute = createdAt.minute.toString().padLeft(2, '0');
      return 'Today, ${hour == 0 ? 12 : hour}:$minute $period';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';
    }
  }
}
