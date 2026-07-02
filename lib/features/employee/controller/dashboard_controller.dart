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

  static const int announcementPageSize = 5;
  final announcementPage = 0.obs;
  final hasMoreAnnouncements = true.obs;
  final isLoadingAnnouncements = false.obs;

  static const int activityPageSize = 10;
  final activityPage = 0.obs;
  final hasMoreActivities = true.obs;
  final isLoadingActivities = false.obs;

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
    await loadAnnouncements(refresh: true);

    await loadActivities(employeeId, refresh: true);

    holidays.value = await dashboardService.getUpcomingHolidays();

    schedules.value = await scheduleService.getUpcomingSchedule(employeeId);

    final balance = await leaveService.getLeaveBalance(employeeId);

    if (balance != null) {
      leaveBalanceDays.value =
          (balance['annual_leave'] ?? 0) +
          (balance['sick_leave'] ?? 0) +
          (balance['casual_leave'] ?? 0);
    }
  }

  Future<void> loadAnnouncements({bool refresh = false}) async {
    if (isLoadingAnnouncements.value) return;

    isLoadingAnnouncements.value = true;

    try {
      if (refresh) {
        announcementPage.value = 0;
        hasMoreAnnouncements.value = true;
        announcements.clear();
      }

      if (!hasMoreAnnouncements.value) return;

      final data = await dashboardService.getAnnouncements(
        page: announcementPage.value,
        limit: announcementPageSize,
      );

      announcements.addAll(data);

      if (data.length < announcementPageSize) {
        hasMoreAnnouncements.value = false;
      } else {
        announcementPage.value++;
      }
    } finally {
      isLoadingAnnouncements.value = false;
    }
  }

  Future<void> loadMoreAnnouncements() async {
    await loadAnnouncements();
  }

  Future<void> resetAnnouncements() async {
    announcementPage.value = 0;
    hasMoreAnnouncements.value = true;
    announcements.clear();

    await loadAnnouncements(refresh: true);
  }

  Future<void> loadActivities(String employeeId, {bool refresh = false}) async {
    if (isLoadingActivities.value) return;

    isLoadingActivities.value = true;

    try {
      if (refresh) {
        activityPage.value = 0;
        hasMoreActivities.value = true;
        recentActivities.clear();
      }

      if (!hasMoreActivities.value) return;

      final data = await dashboardService.getRecentActivities(
        employeeId,
        page: activityPage.value,
        limit: activityPageSize,
      );

      recentActivities.addAll(data);

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
    final user = authController.user;
    if (user == null) return;
    await loadActivities(user.id);
  }

  Future<void> resetActivities() async {
    final user = authController.user;

    if (user == null) return;

    activityPage.value = 0;
    hasMoreActivities.value = true;
    recentActivities.clear();

    await loadActivities(user.id, refresh: true);
  }
}
