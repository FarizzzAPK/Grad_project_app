
import 'dart:convert';

PatientDataModel patientDataModelFromJson(String str) =>
    PatientDataModel.fromJson(json.decode(str));

String patientDataModelToJson(PatientDataModel data) =>
    json.encode(data.toJson());

class PatientDataModel {
  PatientDataModel({required this.data, required this.success, this.message});

  Data data;
  bool success;
  String? message;

  factory PatientDataModel.fromJson(Map<dynamic, dynamic> json) =>
      PatientDataModel(
        data: Data.fromJson(json["data"]),
        success: json["success"],
        message: json["message"],
      );

  Map<dynamic, dynamic> toJson() => {
    "data": data.toJson(),
    "success": success,
    "message": message,
  };
}

class Data {
  Data({
    required this.userId,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.emailConfirmed,
    required this.phoneNumberConfirmed,
    this.imagePath,
    required this.gender,
    this.bloodType,
    this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
    this.medicalRecord,
  });

  int userId;
  String userName;
  String email;
  String phoneNumber;
  bool emailConfirmed;
  bool phoneNumberConfirmed;
  String? imagePath;
  String gender;
  String? bloodType;
  DateTime? dateOfBirth;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic medicalRecord;

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
    userId: json["userId"] ?? 0,
    userName: json["userName"] ?? '',
    email: json["email"] ?? '',
    phoneNumber: json["phoneNumber"] ?? '',
    emailConfirmed: json["emailConfirmed"] ?? false,
    phoneNumberConfirmed: json["phoneNumberConfirmed"] ?? false,
    imagePath: json["imagePath"],
    gender: json["gender"] ?? 'Unknown',
    bloodType: json["bloodType"],
    dateOfBirth: json["dateOfBirth"] != null
        ? DateTime.tryParse(json["dateOfBirth"])
        : null,
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    medicalRecord: json["medicalRecord"],
  );

  /// Returns a formatted blood type string (e.g. "B+" instead of "B_Positive")
  String get formattedBloodType {
    if (bloodType == null) return 'N/A';
    final map = {
      'A_Positive': 'A+',
      'A_Negative': 'A-',
      'B_Positive': 'B+',
      'B_Negative': 'B-',
      'AB_Positive': 'AB+',
      'AB_Negative': 'AB-',
      'O_Positive': 'O+',
      'O_Negative': 'O-',
    };
    return map[bloodType] ?? bloodType!;
  }

  Map<dynamic, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "email": email,
    "phoneNumber": phoneNumber,
    "emailConfirmed": emailConfirmed,
    "phoneNumberConfirmed": phoneNumberConfirmed,
    "imagePath": imagePath,
    "gender": gender,
    "bloodType": bloodType,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "medicalRecord": medicalRecord,
  };
}
