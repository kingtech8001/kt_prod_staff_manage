import 'dart:async';

import 'package:get/get.dart';

import '../core/controllers/auth_controller.dart';
import '../core/services/attendance_service.dart';
import '../core/widgets/snackbar.dart';

class AttendanceController extends GetxController {
  final AttendanceService service = AttendanceService();
  final AuthController authController = Get.find<AuthController>();

  final todayAttendance = Rxn<Map<String, dynamic>>();

  final attendanceHistory = <Map<String, dynamic>>[].obs;

  RxList<Map<String, dynamic>> get attendanceList => attendanceHistory;

  final isLoading = false.obs;

  final attendancePercentage = 0.0.obs;
  final workingDays = 0.obs;
  final lateDays = 0.obs;
  final overtimeHours = 0.0.obs;

  final averageHours = 0.0.obs;
  final averageArrivalTime = '--'.obs;
  final longestDayHours = 0.0.obs;
  final currentStreak = 0.obs;

  final attendanceMap = <String, Map<String, dynamic>>{}.obs;

  final workDuration = Duration.zero.obs;
  final breakDuration = Duration.zero.obs;

  static const attendancePageSize = 10;
  final attendancePage = 0.obs;
  final hasMoreAttendance = true.obs;
  final isLoadingMore = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    ever(authController.currentUser, (user) {
      if (user != null) {
        loadAttendance(user.id);
      } else {
        _clearState();
      }
    });

    if (authController.user != null) {
      loadAttendance(authController.user!.id);
    }
  }

  Future<void> loadAttendance(String employeeId) async {
    try {
      isLoading.value = true;

      await loadTodayAttendance(employeeId);

      await resetAttendance(employeeId);

      _calculateAttendanceMetrics();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAttendanceHistory(
    String employeeId, {
    bool refresh = false,
  }) async {
    if (isLoadingMore.value) return;

    isLoadingMore.value = true;

    try {
      if (refresh) {
        attendancePage.value = 0;
        hasMoreAttendance.value = true;
        attendanceHistory.clear();
      }

      if (!hasMoreAttendance.value) return;

      final data = await service.getAttendance(
        employeeId,
        page: attendancePage.value,
        limit: attendancePageSize,
      );

      attendanceHistory.addAll(data);

      if (data.length < attendancePageSize) {
        hasMoreAttendance.value = false;
      } else {
        attendancePage.value++;
      }

      _calculateAttendanceMetrics();
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreAttendance() async {
    final user = authController.user;

    if (user == null) return;

    await loadAttendanceHistory(user.id);
  }

  Future<void> resetAttendance(String employeeId) async {
    await loadAttendanceHistory(employeeId, refresh: true);
  }

  Future<void> loadTodayAttendance(String employeeId) async {
    final attendance = await service.getTodayAttendance(employeeId);

    todayAttendance.value = attendance;

    if (attendance != null) {
      startLiveTimer();
    } else {
      _timer?.cancel();
      workDuration.value = Duration.zero;
      breakDuration.value = Duration.zero;
    }
  }

  void _calculateAttendanceMetrics() {
    workingDays.value = attendanceHistory.length;

    if (attendanceHistory.isEmpty) {
      attendancePercentage.value = 0;
      lateDays.value = 0;
      overtimeHours.value = 0;
      averageHours.value = 0;
      longestDayHours.value = 0;
      averageArrivalTime.value = '--';
      currentStreak.value = 0;
      attendanceMap.clear();
      return;
    }

    final presentCount = attendanceHistory
        .where((e) => e['status'] == 'Present')
        .length;

    attendancePercentage.value =
        (presentCount / attendanceHistory.length) * 100;

    lateDays.value = attendanceHistory
        .where((e) => e['is_late'] == true)
        .length;

    overtimeHours.value = attendanceHistory.fold<double>(
      0,
      (sum, item) => sum + (((item['overtime_hours'] ?? 0) as num).toDouble()),
    );

    averageHours.value =
        attendanceHistory.fold<double>(
          0,
          (sum, item) => sum + (((item['total_hours'] ?? 0) as num).toDouble()),
        ) /
        attendanceHistory.length;

    longestDayHours.value = attendanceHistory
        .map((e) => ((e['total_hours'] ?? 0) as num).toDouble())
        .fold(0.0, (a, b) => b > a ? b : a);

    _calculateAverageArrival();
    _calculateStreak();

    attendanceMap.clear();

    for (final item in attendanceHistory) {
      attendanceMap[item['attendance_date']] = item;
    }
  }

  void _calculateAverageArrival() {
    final punchIns = attendanceHistory
        .where((e) => e['punch_in'] != null)
        .toList();

    if (punchIns.isEmpty) {
      averageArrivalTime.value = '--';
      return;
    }

    int totalMinutes = 0;

    for (final item in punchIns) {
      final date = DateTime.parse(item['punch_in']).toLocal();

      totalMinutes += date.hour * 60 + date.minute;
    }

    final avgMinutes = (totalMinutes / punchIns.length).round();

    final hours = avgMinutes ~/ 60;
    final minutes = avgMinutes % 60;

    averageArrivalTime.value =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  void _calculateStreak() {
    int streak = 0;

    for (final item in attendanceHistory) {
      if (item['status'] == 'Present') {
        streak++;
      } else {
        break;
      }
    }

    currentStreak.value = streak;
  }

  void _clearState() {
    todayAttendance.value = null;
    attendanceHistory.clear();

    workDuration.value = Duration.zero;
    breakDuration.value = Duration.zero;

    attendancePercentage.value = 0;
    workingDays.value = 0;
    lateDays.value = 0;
    overtimeHours.value = 0;
    averageHours.value = 0;
    longestDayHours.value = 0;
    averageArrivalTime.value = '--';
    currentStreak.value = 0;

    attendanceMap.clear();

    _timer?.cancel();
  }

  Future<void> punchIn() async {
    try {
      final user = authController.user;

      if (user == null) return;

      await service.punchIn(user.id);

      await loadAttendance(user.id);

      CommonSnackbar.success('Success', 'Punched in successfully');
    } catch (e) {
      CommonSnackbar.error('Error', e.toString());
    }
  }

  Future<void> punchOut() async {
    try {
      final attendance = todayAttendance.value;

      if (attendance == null) return;

      await service.punchOut(attendance['id']);

      await loadAttendance(authController.user!.id);

      CommonSnackbar.success('Success', 'Punched out successfully');
    } catch (e) {
      CommonSnackbar.error('Error', e.toString());
    }
  }

  Future<void> startBreak() async {
    try {
      final attendance = todayAttendance.value;

      if (attendance == null) return;

      await service.startBreak(attendance['id']);

      await loadTodayAttendance(authController.user!.id);

      CommonSnackbar.success('Success', 'Break started');
    } catch (e) {
      CommonSnackbar.error('Error', e.toString());
    }
  }

  Future<void> stopBreak() async {
    try {
      final attendance = todayAttendance.value;

      if (attendance == null) return;

      await service.stopBreak(attendance['id']);

      await loadTodayAttendance(authController.user!.id);

      CommonSnackbar.success('Success', 'Break ended');
    } catch (e) {
      CommonSnackbar.error('Error', e.toString());
    }
  }

  void startLiveTimer() {
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
    }

    if (state == 'On Break') {
      final activeBreak = await service.getActiveBreak(attendance['id']);

      if (activeBreak != null) {
        final breakStart = DateTime.parse(activeBreak['break_start']);

        breakDuration.value = DateTime.now().toUtc().difference(
          breakStart.toUtc(),
        );
      }
    }
  }

  @override
  void onClose() {
    _timer?.cancel();

    super.onClose();
  }
}
