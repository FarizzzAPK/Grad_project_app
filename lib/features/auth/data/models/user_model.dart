class UserModel {
  final String username;
  final String email;
  final String phoneNumber;
  final String? password;
  final String? confirmPassword;
  final bool isDoctor;
  final String? professionalPracticeLicense;
  final String? issuingAuthority;

  UserModel({
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.password,
    this.confirmPassword,
    this.isDoctor = false,
    this.professionalPracticeLicense,
    this.issuingAuthority,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      isDoctor: json['isDoctor'] as bool? ?? false,
      professionalPracticeLicense:
          json['professionalPracticeLicense'] as String?,
      issuingAuthority: json['issuingAuthority'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password ?? '',
      'confirmPassword': confirmPassword ?? '',
      'isDoctor': isDoctor,
      'professionalPracticeLicense': professionalPracticeLicense ?? '',
      'issuingAuthority': issuingAuthority ?? '',
    };
  }
}
