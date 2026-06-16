import 'package:get/get.dart';
import '../repository/hr_repository.dart';

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
  }

  Future<void> markAbsent(DateTime date) async {
    if (employee.value == null) return;

    await repository.markAttendanceStatus(employeeId: employee.value!['id'], date: date, status: 'Absent');

    await loadEmployee(employee.value!['id']);
  }

  Future<void> markLeave(DateTime date) async {
    if (employee.value == null) return;

    await repository.markAttendanceStatus(employeeId: employee.value!['id'], date: date, status: 'Leave');

    await loadEmployee(employee.value!['id']);
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
}
