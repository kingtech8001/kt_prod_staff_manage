import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/services/attendance_service.dart';

class AttendanceController extends GetxController {
  final service = AttendanceService();
  final attendanceList = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final attendancePercentage = 0.0.obs;
  final workingDays = 0.obs;

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
  }
}
