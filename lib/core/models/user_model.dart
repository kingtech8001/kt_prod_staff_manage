import 'package:staff_managememt_system/core/models/user_role.dart';

class UserModel {
  final String id;
  final String employeeCode;
  final String fullName;
  final String email;
  final String role;

  UserRole get userRole => UserRoleExtension.fromString(role);

  final String? department;
  final String? designation;
  final String? phone;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.employeeCode,
    required this.fullName,
    required this.email,
    required this.role,
    this.department,
    this.designation,
    this.phone,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      employeeCode: json['employee_code'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      department: json['department'],
      designation: json['designation'],
      phone: json['phone'],
      profileImage: json['profile_image'],
    );
  }
}
