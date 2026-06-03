import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/services/attendance_service.dart';

class DashboardController extends GetxController {
  final service = AttendanceService();

  final attendanceList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    final user = Get.find<AuthController>().user;

    if (user != null) {
      loadAttendance(user.id);
    }
  }

  Future<void> loadAttendance(String employeeId) async {
    attendanceList.value = await service.getAttendance(employeeId);
  }
}
