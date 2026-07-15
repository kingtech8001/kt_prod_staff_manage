import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../shared/employee_management_controller.dart';
import '../repository/hr_repository.dart';
import 'employee_directory_controller.dart';

class EmployeeProfileController extends GetxController {
  final selectedTab = 'Overview'.obs;
  final employeeActivities = <Map<String, dynamic>>[].obs;
  final repository = HrRepository();

  final employee = Rxn<Map<String, dynamic>>();

  final profileRole = RxString('Employee');

  final selectedMonth = DateTime.now().obs;

  String get selectedMonthText =>
      DateFormat('MMMM yyyy').format(selectedMonth.value);

  final attendanceHistory = <Map<String, dynamic>>[].obs;
  final activities = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;

  final attendanceRate = 0.0.obs;
  final lateDays = 0.obs;
  final overtimeHours = 0.0.obs;
  final averageHours = 0.0.obs;

  static const activityPageSize = 10;
  final activityPage = 0.obs;
  final hasMoreActivities = true.obs;
  final isLoadingActivities = false.obs;

  static const attendancePageSize = 10;
  final attendancePage = 0.obs;
  final hasMoreAttendance = true.obs;
  final isLoadingAttendance = false.obs;

  final todayAttendance = Rxn<Map<String, dynamic>>();
  final workDuration = Duration.zero.obs;
  final breakDuration = Duration.zero.obs;
  Timer? _timer;
  Timer? _refreshTimer;

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  @override
  void onClose() {
    _timer?.cancel();
    _refreshTimer?.cancel();
    super.onClose();
  }

  Future<void> changeAttendanceMonth(DateTime month) async {
    selectedMonth.value = month;

    if (employee.value == null) return;

    await resetAttendance(employee.value!['id']);

    _calculateStats();
  }

  void setProfileRole(String role) {
    profileRole.value = role;
  }

  Future<void> loadEmployee(String employeeId) async {
    try {
      isLoading.value = true;

      employee.value = await repository.getEmployeeById(employeeId);

      todayAttendance.value = await repository.getTodayAttendance(employeeId);

      _startTimer();

      await resetAttendance(employeeId);

      await resetActivities(employeeId);

      _calculateStats();
    } finally {
      isLoading.value = false;
    }
  }

  void _startTimer() {
    _timer?.cancel();

    _updateTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTimer());

    _refreshTimer?.cancel();

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => refreshTodayAttendance(),
    );
  }

  Future<void> _updateTimer() async {
    final attendance = todayAttendance.value;

    if (attendance == null) return;

    final state = attendance['current_state'];

    if (state == 'Present') {
      final punchIn = DateTime.parse(attendance['punch_in']).toLocal();

      workDuration.value = DateTime.now().difference(punchIn);

      breakDuration.value = Duration.zero;
    }

    if (state == 'On Break') {
      final activeBreak = await repository.getActiveBreak(attendance['id']);

      if (activeBreak != null) {
        final breakStart = DateTime.parse(activeBreak['break_start']).toLocal();

        breakDuration.value = DateTime.now().difference(breakStart);
      }
    }
  }

  void _calculateStats() {
    if (attendanceHistory.isEmpty) return;

    final totalDays = attendanceHistory.length;

    final presentDays = attendanceHistory
        .where((e) => e['status'] == 'Present')
        .length;

    final lateCount = attendanceHistory
        .where((e) => e['is_late'] == true)
        .length;

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

    await repository.markAttendanceStatus(
      employeeId: employee.value!['id'],
      date: date,
      status: 'Present',
    );

    await loadEmployee(employee.value!['id']);

    await Get.find<EmployeeDirectoryController>().loadDashboardStats();
  }

  Future<void> markAbsent(DateTime date) async {
    if (employee.value == null) return;

    await repository.markAttendanceStatus(
      employeeId: employee.value!['id'],
      date: date,
      status: 'Absent',
    );

    await loadEmployee(employee.value!['id']);
    await Get.find<EmployeeDirectoryController>().loadDashboardStats();
  }

  Future<void> markLeave(DateTime date) async {
    if (employee.value == null) return;

    await repository.markAttendanceStatus(
      employeeId: employee.value!['id'],
      date: date,
      status: 'Leave',
    );

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

  Future<void> loadAttendance({
    required String employeeId,
    bool refresh = false,
  }) async {
    if (isLoadingAttendance.value) return;

    isLoadingAttendance.value = true;

    try {
      if (refresh) {
        attendancePage.value = 0;
        hasMoreAttendance.value = true;
        attendanceHistory.clear();
      }

      if (!hasMoreAttendance.value) return;

      final data = await repository.getEmployeeAttendance(
        employeeId,
        month: selectedMonth.value.month,
        year: selectedMonth.value.year,
        page: attendancePage.value,
        limit: attendancePageSize,
      );

      attendanceHistory.addAll(data);

      if (data.length < attendancePageSize) {
        hasMoreAttendance.value = false;
      } else {
        attendancePage.value++;
      }

      _calculateStats();
    } finally {
      isLoadingAttendance.value = false;
    }
  }

  Future<void> loadMoreAttendance() async {
    if (employee.value == null) return;

    await loadAttendance(employeeId: employee.value!['id']);
  }

  Future<void> resetAttendance(String employeeId) async {
    await loadAttendance(employeeId: employeeId, refresh: true);
  }
  /*
  Future<void> loadEmployeeActivities(String employeeId) async {
    try {
      employeeActivities.value = await repository.getEmployeeActivities(
        employeeId,
      );
    } catch (e) {
      print(e);
    }
  }*/

  Future<void> updateEmployee({
    required String fullName,
    required String email,
    required String phone,
    required String designation,
    required bool isActive,
  }) async {
    if (employee.value == null) return;

    await repository.updateEmployee(
      employeeId: employee.value!['id'],
      fullName: fullName,
      email: email,
      phone: phone,
      designation: designation,
      isActive: isActive,
    );

    await loadEmployee(employee.value!['id']);

    await Get.find<EmployeeDirectoryController>().loadEmployees();

    final authController = Get.find<AuthController>();

    if (authController.currentUser.value?.id == employee.value!['id']) {
      await authController.refreshCurrentUser();
    }

    final controller = Get.find<EmployeeManagementController>();

    controller.selectedEmployee.value = Map<String, dynamic>.from(
      employee.value!,
    );
  }

  Future<void> loadActivities(String employeeId, {bool refresh = false}) async {
    if (isLoadingActivities.value) return;

    isLoadingActivities.value = true;

    final data = await repository.getEmployeeActivities(
      employeeId,
      page: activityPage.value,
      limit: activityPageSize,
    );

    try {
      if (refresh) {
        activityPage.value = 0;
        hasMoreActivities.value = true;
        activities.clear();
      }

      if (!hasMoreActivities.value) return;

      final data = await repository.getEmployeeActivities(
        employeeId,
        page: activityPage.value,
        limit: activityPageSize,
      );

      activities.addAll(data);

      if (data.length < activityPageSize) {
        hasMoreActivities.value = false;
      } else {
        activityPage.value++;
      }
    } finally {
      isLoadingActivities.value = false;
    }
  }

  Future<void> loadMoreActivities() async {
    if (employee.value == null) return;

    await loadActivities(employee.value!['id']);
  }

  Future<void> resetActivities(String employeeId) async {
    await loadActivities(employeeId, refresh: true);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return '${twoDigits(duration.inHours)}:'
        '${twoDigits(duration.inMinutes.remainder(60))}:'
        '${twoDigits(duration.inSeconds.remainder(60))}';
  }

  Future<void> refreshTodayAttendance() async {
    if (employee.value == null) return;

    todayAttendance.value = await repository.getTodayAttendance(
      employee.value!['id'],
    );
  }
}
