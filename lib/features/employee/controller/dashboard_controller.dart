import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/services/attendance_service.dart';

class DashboardController extends GetxController {
  final service = AttendanceService();
  final todayAttendance = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();

    final authController = Get.find<AuthController>();

    // React whenever currentUser changes (including on restore)
    ever(authController.currentUser, (user) {
      if (user != null) {
        loadTodayAttendance(user.id);
      } else {
        todayAttendance.value = null;
      }
    });

    // Also load immediately if user is already available
    if (authController.user != null) {
      loadTodayAttendance(authController.user!.id);
    }
  }

  Future<void> loadTodayAttendance(String employeeId) async {
    final attendance = await service.getTodayAttendance(employeeId);
    todayAttendance.value = attendance;
  }
}
