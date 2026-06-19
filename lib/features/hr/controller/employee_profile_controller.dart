import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../repository/hr_repository.dart';
import 'employee_directory_controller.dart';
import 'hr_controller.dart';

class EmployeeProfileController extends GetxController {
  final selectedTab = 'Overview'.obs;
  final employeeActivities = <Map<String, dynamic>>[].obs;
  final repository = HrRepository();

  final employee = Rxn<Map<String, dynamic>>();

  final attendanceHistory = <Map<String, dynamic>>[].obs;
  final activities = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;

  final attendanceRate = 0.0.obs;
  final lateDays = 0.obs;
  final overtimeHours = 0.0.obs;
  final averageHours = 0.0.obs;

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  Future<void> loadEmployee(String employeeId) async {
    try {
      isLoading.value = true;

      employee.value = await repository.getEmployeeById(employeeId);

      attendanceHistory.value = await repository.getEmployeeAttendance(employeeId);

      activities.value = await repository.getEmployeeActivities(employeeId);

      _calculateStats();
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateStats() {
    if (attendanceHistory.isEmpty) return;

    final totalDays = attendanceHistory.length;

    final presentDays = attendanceHistory.where((e) => e['status'] == 'Present').length;

    final lateCount = attendanceHistory.where((e) => e['is_late'] == true).length;

    double totalHours = 0;
    double totalOt = 0;

    for (final row in attendanceHistory) {
      totalHours += (row['total_hours'] ?? 0).toDouble();

      totalOt += (row['overtime_hours'] ?? 0).toDouble();
    }

    attendanceRate.value = (presentDays / totalDays) * 100;

    lateDays.value = lateCount;

    overtimeHours.value = totalOt;

    averageHours.value = totalHours / totalDays;
  }

  Future<void> markPresent(DateTime date) async {
    if (employee.value == null) return;

    await repository.markAttendanceStatus(employeeId: employee.value!['id'], date: date, status: 'Present');

    await loadEmployee(employee.value!['id']);

    await Get.find<EmployeeDirectoryController>().loadDashboardStats();
  }

  Future<void> markAbsent(DateTime date) async {
    if (employee.value == null) return;

    await repository.markAttendanceStatus(employeeId: employee.value!['id'], date: date, status: 'Absent');

    await loadEmployee(employee.value!['id']);
    await Get.find<EmployeeDirectoryController>().loadDashboardStats();
  }

  Future<void> markLeave(DateTime date) async {
    if (employee.value == null) return;

    await repository.markAttendanceStatus(employeeId: employee.value!['id'], date: date, status: 'Leave');

    await loadEmployee(employee.value!['id']);
    await Get.find<EmployeeDirectoryController>().loadDashboardStats();
  }

  Future<void> approveLeave() async {
    if (employee.value == null) return;

    await repository.approveLatestLeave(employee.value!['id'], 'HR');

    await loadEmployee(employee.value!['id']);
  }

  Future<void> rejectLeave() async {
    if (employee.value == null) return;

    await repository.rejectLatestLeave(employee.value!['id'], 'HR');

    await loadEmployee(employee.value!['id']);
  }

  Future<void> loadEmployeeActivities(String employeeId) async {
    try {
      employeeActivities.value = await repository.getEmployeeActivities(employeeId);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateEmployee({required String fullName, required String email, required String phone, required String designation, required bool isActive}) async {
    if (employee.value == null) return;

    await repository.updateEmployee(employeeId: employee.value!['id'], fullName: fullName, email: email, phone: phone, designation: designation, isActive: isActive);

    await loadEmployee(employee.value!['id']);

    await Get.find<EmployeeDirectoryController>().loadEmployees();

    final authController = Get.find<AuthController>();

    if (authController.currentUser.value?.id == employee.value!['id']) {
      await authController.refreshCurrentUser();
    }

    final hrController = Get.find<HrController>();

    hrController.selectedEmployee.value = Map<String, dynamic>.from(employee.value!);
  }
}
