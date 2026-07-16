import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../shared/employee_management_controller.dart';
import '../../admin/controller/attendance_analysis_controller.dart';
import '../repository/hr_repository.dart';
import 'employee_directory_controller.dart';

class EmployeeProfileController extends GetxController {
  final selectedTab = 'Overview'.obs;
  final employeeActivities = <Map<String, dynamic>>[].obs;
  final repository = HrRepository();

  final currentAttendancePage = 0.obs;
  final rowsPerPage = 10.obs;
  final totalRecords = 0.obs;

  final employee = Rxn<Map<String, dynamic>>();

  final profileRole = RxString('Employee');

  final selectedMonth = DateTime.now().obs;

  String get selectedMonthText =>
      DateFormat('MMMM yyyy').format(selectedMonth.value);

  int get totalAttendancePages {
    if (totalAttendanceRecords.value == 0) return 1;

    return (totalAttendanceRecords.value / rowsPerPage.value).ceil();
  }

  final attendanceHistory = <Map<String, dynamic>>[].obs;
  final activities = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;

  final isRefreshing = false.obs;

  final attendanceRate = 0.0.obs;
  final lateDays = 0.obs;
  final overtimeHours = 0.0.obs;
  final averageHours = 0.0.obs;

  static const activityPageSize = 10;
  final activityPage = 0.obs;
  final hasMoreActivities = true.obs;
  final isLoadingActivities = false.obs;

  final totalAttendanceRecords = 0.obs;

  final isLoadingAttendance = false.obs;

  final todayAttendance = Rxn<Map<String, dynamic>>();
  final workDuration = Duration.zero.obs;
  final breakDuration = Duration.zero.obs;
  Timer? _timer;

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> changeAttendanceMonth(DateTime month) async {
    selectedMonth.value = month;

    currentAttendancePage.value = 0;

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

      if (Get.isRegistered<AttendanceAnalysisController>()) {
        await Get.find<AttendanceAnalysisController>().initialize(employeeId);
      }

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

  Future<void> markPresent(
    DateTime date,
    TimeOfDay? punchIn,
    TimeOfDay? punchOut,
  ) async {
    if (employee.value == null) return;

    if (punchIn == null || punchOut == null) return;

    await repository.markAttendanceStatus(
      employeeId: employee.value!['id'],
      date: date,
      status: 'Present',
      punchIn: punchIn,
      punchOut: punchOut,
    );

    await loadEmployee(employee.value!['id']);

    await Get.find<EmployeeDirectoryController>().loadDashboardStats();
  }

  Future<void> markAbsent(DateTime date, TimeOfDay? _, TimeOfDay? __) async {
    if (employee.value == null) return;

    await repository.markAttendanceStatus(
      employeeId: employee.value!['id'],
      date: date,
      status: 'Absent',
    );

    await loadEmployee(employee.value!['id']);
    await Get.find<EmployeeDirectoryController>().loadDashboardStats();
  }

  Future<void> markLeave(DateTime date, TimeOfDay? _, TimeOfDay? __) async {
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
        attendanceHistory.clear();
      }

      final data = await repository.getEmployeeAttendance(
        employeeId,
        month: selectedMonth.value.month,
        year: selectedMonth.value.year,
        page: currentAttendancePage.value,
        limit: rowsPerPage.value,
      );

      attendanceHistory.assignAll(
        List<Map<String, dynamic>>.from(data['data']),
      );

      totalRecords.value = data['count'];

      _calculateStats();
    } finally {
      isLoadingAttendance.value = false;
    }
  }

  Future<void> resetAttendance(String employeeId) async {
    await loadAttendance(employeeId: employeeId, refresh: true);
  }

  Future<void> nextAttendancePage() async {
    if (employee.value == null) return;

    final totalPages = (totalRecords.value / rowsPerPage.value).ceil();

    if (currentAttendancePage.value >= totalPages - 1) return;

    currentAttendancePage.value++;

    await loadAttendance(employeeId: employee.value!['id']);
  }

  Future<void> previousAttendancePage() async {
    if (employee.value == null) return;

    if (currentAttendancePage.value == 0) return;

    currentAttendancePage.value--;

    await loadAttendance(employeeId: employee.value!['id']);
  }

  Future<void> changeRowsPerPage(int value) async {
    if (employee.value == null) return;

    rowsPerPage.value = value;
    currentAttendancePage.value = 0;

    await loadAttendance(employeeId: employee.value!['id'], refresh: true);
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

  Future<void> refreshProfile() async {
    final id = employee.value!['id'];

    isRefreshing.value = true;

    try {
      employee.value = await repository.getEmployeeById(id);

      todayAttendance.value = await repository.getTodayAttendance(id);

      await resetAttendance(id);

      await resetActivities(id);

      _calculateStats();

      if (Get.isRegistered<AttendanceAnalysisController>()) {
        await Get.find<AttendanceAnalysisController>().loadChart();
      }

      final directory = Get.find<EmployeeDirectoryController>();

      await directory.loadDashboardStats();
      await directory.loadLiveActivities();
    } finally {
      isRefreshing.value = false;
    }
  }
}
