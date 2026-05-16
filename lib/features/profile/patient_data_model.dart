
import 'dart:convert';

PatientDataModel patientDataModelFromJson(String str) =>
    PatientDataModel.fromJson(json.decode(str));

String patientDataModelToJson(PatientDataModel data) =>
    json.encode(data.toJson());

class PatientDataModel {
  PatientDataModel({required this.data, required this.success});

  Data data;
  bool success;

  factory PatientDataModel.fromJson(Map<dynamic, dynamic> json) =>
      PatientDataModel(
        data: Data.fromJson(json["data"]),
        success: json["success"],
      );

  Map<dynamic, dynamic> toJson() => {"data": data.toJson(), "success": success};
}

class Data {
  Data({
    required this.emailConfirmed,
    required this.gender,
    required this.userName,
    required this.userId,
    required this.phoneNumberConfirmed,
    required this.createdAt,
    required this.phoneNumber,
    required this.email,
    required this.updatedAt,
  });

  bool emailConfirmed;
  int gender;
  String userName;
  int userId;
  bool phoneNumberConfirmed;
  DateTime createdAt;
  String phoneNumber;
  String email;
  DateTime updatedAt;

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
    emailConfirmed: json["emailConfirmed"],
    gender: json["gender"],
    userName: json["userName"],
    userId: json["userId"],
    phoneNumberConfirmed: json["phoneNumberConfirmed"],
    createdAt: DateTime.parse(json["createdAt"]),
    phoneNumber: json["phoneNumber"],
    email: json["email"],
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<dynamic, dynamic> toJson() => {
    "emailConfirmed": emailConfirmed,
    "gender": gender,
    "userName": userName,
    "userId": userId,
    "phoneNumberConfirmed": phoneNumberConfirmed,
    "createdAt": createdAt.toIso8601String(),
    "phoneNumber": phoneNumber,
    "email": email,
    "updatedAt": updatedAt.toIso8601String(),
  };
}
