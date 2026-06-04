import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../core/services/performance_service.dart';

class PerformanceController extends GetxController {
  final service = PerformanceService();

  final reviews = <Map<String, dynamic>>[].obs;
  final achievements = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;
  final attendancePercent = 0.0.obs;
  final workingDays = 0.obs;
  final leavesTaken = 0.obs;
  final averageRating = 0.0.obs;

  final performanceMetrics = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();

    final authController = Get.find<AuthController>();

    ever(authController.currentUser, (user) {
      if (user != null) {
        loadPerformance(user.id);
      } else {
        reviews.clear();
        achievements.clear();
      }
    });

    if (authController.user != null) {
      loadPerformance(authController.user!.id);
    }
  }

  Future<void> loadPerformance(String employeeId) async {
    try {
      isLoading.value = true;

      reviews.value = await service.getReviews(employeeId);

      achievements.value = await service.getAchievements(employeeId);

      final attendance = await service.getAttendance(employeeId);

      final leaves = await service.getLeaves(employeeId);

      workingDays.value = attendance.length;

      leavesTaken.value = leaves.where((e) => e['status'] == 'Approved').length;

      final metrics = await service.getPerformanceMetrics(employeeId);

      performanceMetrics.value = metrics;

      print('METRICS => $metrics');

      if (reviews.isNotEmpty) {
        averageRating.value =
            reviews.map((e) => (e['rating'] as num).toDouble()).reduce((a, b) => a + b) /
            reviews.length;
      }

      final presentDays = attendance.where((e) => e['status'] == 'Present').length;

      if (attendance.isNotEmpty) {
        attendancePercent.value = (presentDays / attendance.length) * 100;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
