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
      username: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      isDoctor: json['isDoctor'] as bool? ?? false,
      professionalPracticeLicense:
          json['professionalPracticeLicense'] as String?,
      issuingAuthority: json['issuingAuthority'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'isDoctor': isDoctor,
    };

    if (password != null) {
      data['password'] = password;
    }
    if (confirmPassword != null) {
      data['confirmPassword'] = confirmPassword;
    }

    if (professionalPracticeLicense != null &&
        professionalPracticeLicense!.isNotEmpty) {
      data['professionalPracticeLicense'] = professionalPracticeLicense;
    }
    if (issuingAuthority != null && issuingAuthority!.isNotEmpty) {
      data['issuingAuthority'] = issuingAuthority;
    }

    return data;
  }
}
