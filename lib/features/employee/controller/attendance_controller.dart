import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/services/attendance_service.dart';

class AttendanceController extends GetxController {
  final service = AttendanceService();
  final attendanceList = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final attendancePercentage = 0.0.obs;
  final workingDays = 0.obs;
  final lateDays = 0.obs;
  final overtimeHours = 0.0.obs;
  final attendanceMap = <String, Map<String, dynamic>>{}.obs;
  final averageHours = 0.0.obs;
  final averageArrivalTime = '00'.obs;
  final longestDayHours = 0.0.obs;
  final currentStreak = 0.obs;

  @override
  void onInit() {
    super.onInit();

    final authController = Get.find<AuthController>();

    // React whenever user changes (covers hot restart + fresh login)
    ever(authController.currentUser, (user) {
      if (user != null) {
        loadAttendance(user.id);
      } else {
        attendanceList.clear();
      }
    });

    // Load immediately if user is already available
    if (authController.user != null) {
      loadAttendance(authController.user!.id);
    }
  }

  Future<void> loadAttendance(String userId) async {
    try {
      isLoading.value = true;

      final data = await service.getAttendance(userId);

      attendanceList.value = data;

      _calculateAttendanceMetrics();
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateAttendanceMetrics() {
    workingDays.value = attendanceList.length;

    if (attendanceList.isEmpty) {
      attendancePercentage.value = 0;
      return;
    }

    final presentCount = attendanceList.where((e) => e['status'] == 'Present').length;

    attendancePercentage.value = (presentCount / attendanceList.length) * 100;

    lateDays.value = attendanceList.where((e) => e['is_late'] == true).length;

    overtimeHours.value = attendanceList.fold<double>(
      0,
      (sum, item) => sum + ((item['overtime_hours'] ?? 0).toDouble()),
    );

    averageHours.value =
        attendanceList.fold<double>(
          0,
          (sum, item) => sum + ((item['total_hours'] ?? 0).toDouble()),
        ) /
        attendanceList.length;

    longestDayHours.value = attendanceList
        .map((e) => (e['total_hours'] ?? 0).toDouble())
        .fold(0.0, (previous, current) => current > previous ? current : previous);

    _calculateAverageArrival();
    _calculateStreak();

    attendanceMap.clear();

    for (final item in attendanceList) {
      attendanceMap[item['attendance_date']] = item;
    }
  }

  void _calculateAverageArrival() {
    final punchIns = attendanceList.where((e) => e['punch_in'] != null).toList();

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

    for (final item in attendanceList) {
      if (item['status'] == 'Present') {
        streak++;
      } else {
        break;
      }
    }

    currentStreak.value = streak;
  }
}
