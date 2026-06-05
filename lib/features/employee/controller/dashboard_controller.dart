import 'dart:async';

import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/services/attendance_service.dart';
import '../../../core/services/dashboard_service.dart';
import '../../../core/services/leave_service.dart';
import '../../../core/services/schedule_services.dart';

class DashboardController extends GetxController {
  final service = AttendanceService();
  final todayAttendance = Rxn<Map<String, dynamic>>();
  final announcements = <Map<String, dynamic>>[].obs;
  final holidays = <Map<String, dynamic>>[].obs;
  final recentActivities = <Map<String, dynamic>>[].obs;
  final dashboardService = DashboardService();
  final attendanceHistory = <Map<String, dynamic>>[].obs;
  final scheduleService = ScheduleService();
  final schedules = <Map<String, dynamic>>[].obs;
  final overtimeHours = 0.0.obs;
  final leaveBalanceDays = 0.obs;
  final leaveService = LeaveService();
  final authController = Get.find<AuthController>();
  final workDuration = Duration.zero.obs;
  final breakDuration = Duration.zero.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    final authController = Get.find<AuthController>();

    // React whenever currentUser changes (including on restore)
    ever(authController.currentUser, (user) {
      if (user != null) {
        loadDashboardData(user.id);
      } else {
        todayAttendance.value = null;
      }
    });

    // Also load immediately if user is already available
    if (authController.user != null) {
      loadDashboardData(authController.user!.id);
    }
  }

  Future<void> loadTodayAttendance(String employeeId) async {
    final attendance = await service.getTodayAttendance(employeeId);
    todayAttendance.value = attendance;
    if (attendance != null) {
      startLiveTimer();
    }
  }

  Future<void> loadDashboardData(String employeeId) async {
    await loadTodayAttendance(employeeId);

    announcements.value = await dashboardService.getAnnouncements();

    holidays.value = await dashboardService.getUpcomingHolidays();

    recentActivities.value = await dashboardService.getRecentActivities(employeeId);
    attendanceHistory.value = await service.getAttendance(employeeId);
    schedules.value = await scheduleService.getUpcomingSchedule(employeeId);
    double overtime = 0;

    for (final item in attendanceHistory) {
      final hours = (item['total_hours'] ?? 0) as num;

      if (hours > 8) {
        overtime += (hours - 8);
      }
    }

    overtimeHours.value = overtime;

    final balance = await leaveService.getLeaveBalance(employeeId);

    if (balance != null) {
      leaveBalanceDays.value =
          (balance['annual_leave'] ?? 0) +
          (balance['sick_leave'] ?? 0) +
          (balance['casual_leave'] ?? 0);
    }

    print('SCHEDULES => ${schedules.length}');
    print('ANNOUNCEMENTS => ${announcements.length}');
    print('HOLIDAYS => ${holidays.length}');
    print('ACTIVITIES => ${recentActivities.length}');
    print('ATTENDANCE HISTORY => ${attendanceHistory.length}');
  }

  Future<void> punchIn() async {
    try {
      final user = authController.user;

      if (user == null) return;

      await service.punchIn(user.id);

      await loadTodayAttendance(user.id);

      attendanceHistory.value = await service.getAttendance(user.id);

      Get.snackbar('Success', 'Punched in successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> startBreak() async {
    try {
      final attendance = todayAttendance.value;

      if (attendance == null) return;

      await service.startBreak(attendance['id']);

      await loadTodayAttendance(authController.user!.id);

      Get.snackbar('Success', 'Break started');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> stopBreak() async {
    try {
      final attendance = todayAttendance.value;

      if (attendance == null) return;

      await service.stopBreak(attendance['id']);

      await loadTodayAttendance(authController.user!.id);

      Get.snackbar('Success', 'Break ended');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> punchOut() async {
    try {
      final attendance = todayAttendance.value;

      if (attendance == null) return;

      await service.punchOut(attendance['id']);

      await loadDashboardData(authController.user!.id);

      Get.snackbar('Success', 'Punched out successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void startLiveTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimer();
    });
  }

  void _updateTimer() async {
    final attendance = todayAttendance.value;

    if (attendance == null) return;

    final state = attendance['current_state'];

    if (state == 'Present') {
      final punchIn = DateTime.parse(attendance['punch_in']).toLocal();

      workDuration.value = DateTime.now().difference(punchIn);
    }

    if (state == 'On Break') {
      final activeBreak = await service.getActiveBreak(attendance['id']);

      print('ACTIVE BREAK => $activeBreak');

      if (activeBreak != null) {
        final breakStart = DateTime.parse(activeBreak['break_start']);

        print('BREAK START => $breakStart');
        print('NOW => ${DateTime.now().toUtc()}');

        breakDuration.value = DateTime.now().toUtc().difference(breakStart.toUtc());
      }
    }
  }
}
