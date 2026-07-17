enum UserRole { employee, hr, admin }

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.employee:
        return 'employee';
      case UserRole.hr:
        return 'hr';
      case UserRole.admin:
        return 'admin';
    }
  }

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'employee':
        return UserRole.employee;

      case 'hr':
        return UserRole.hr;

      case 'admin':
        return UserRole.admin;

      default:
        throw Exception('Unknown user role: $role');
    }
  }
}
