import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/services/dashboard_service.dart';
import '../../../core/services/leave_service.dart';
import '../../../core/services/schedule_services.dart';

class DashboardController extends GetxController {
  final announcements = <Map<String, dynamic>>[].obs;
  final holidays = <Map<String, dynamic>>[].obs;
  final recentActivities = <Map<String, dynamic>>[].obs;
  final dashboardService = DashboardService();
  final scheduleService = ScheduleService();
  final schedules = <Map<String, dynamic>>[].obs;
  final leaveBalanceDays = 0.obs;
  final leaveService = LeaveService();
  final authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();

    final authController = Get.find<AuthController>();

    // React whenever currentUser changes (including on restore)
    ever(authController.currentUser, (user) {
      if (user != null) {
        loadDashboardData(user.id);
      }
    });

    // Also load immediately if user is already available
    if (authController.user != null) {
      loadDashboardData(authController.user!.id);
    }
  }

  Future<void> loadDashboardData(String employeeId) async {
    announcements.value = await dashboardService.getAnnouncements();

    holidays.value = await dashboardService.getUpcomingHolidays();

    recentActivities.value = await dashboardService.getRecentActivities(
      employeeId,
    );

    schedules.value = await scheduleService.getUpcomingSchedule(employeeId);

    final balance = await leaveService.getLeaveBalance(employeeId);

    if (balance != null) {
      leaveBalanceDays.value =
          (balance['annual_leave'] ?? 0) +
          (balance['sick_leave'] ?? 0) +
          (balance['casual_leave'] ?? 0);
    }
  }
}
