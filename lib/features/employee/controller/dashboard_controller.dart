import 'package:flutter/material.dart';
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

  final expectedWorkHours = 8.0.obs;
  final breakAllowanceHours = 1.0.obs;

  final announcementScrollController = ScrollController();
  final activityScrollController = ScrollController();

  static const int announcementPageSize = 10;
  final announcementPage = 0.obs;
  final hasMoreAnnouncements = true.obs;
  final isLoadingAnnouncements = false.obs;

  static const int activityPageSize = 10;
  final activityPage = 0.obs;
  final hasMoreActivities = true.obs;
  final isLoadingActivities = false.obs;

  static const int holidayPageSize = 10;
  final holidayPage = 0.obs;
  final hasMoreHolidays = true.obs;
  final isLoadingHolidays = false.obs;
  final holidayScrollController = ScrollController();

  static const int employeeActivityPageSize = 5;
  final employeeActivityPage = 0.obs;
  final hasMoreEmployeeActivities = true.obs;
  final isLoadingEmployeeActivities = false.obs;
  final employeeActivities = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    final authController = Get.find<AuthController>();

    ever(authController.currentUser, (user) {
      if (user != null) {
        loadDashboardData(user.id);
      }
    });

    if (authController.user != null) {
      loadDashboardData(authController.user!.id);
    }

    announcementScrollController.addListener(_announcementScrollListener);
    activityScrollController.addListener(_activityScrollListener);
    holidayScrollController.addListener(_holidayScrollListener);
  }

  @override
  void onClose() {
    announcementScrollController.dispose();
    activityScrollController.dispose();
    holidayScrollController.dispose();
    super.onClose();
  }

  void _announcementScrollListener() {
    if (announcementScrollController.position.pixels >=
        announcementScrollController.position.maxScrollExtent - 200) {
      loadMoreAnnouncements();
    }
  }

  void _activityScrollListener() {
    if (activityScrollController.position.pixels >=
        activityScrollController.position.maxScrollExtent - 200) {
      loadMoreActivities();
    }
  }

  void _holidayScrollListener() {
    if (holidayScrollController.position.pixels >=
        holidayScrollController.position.maxScrollExtent - 200) {
      loadMoreHolidays();
    }
  }

  Future<void> loadDashboardData(String employeeId) async {
    await loadAnnouncements(refresh: true);

    await loadActivities(employeeId, refresh: true);

    await loadEmployeeActivities(refresh: true);

    await loadHolidays(refresh: true);

    schedules.value = await scheduleService.getUpcomingSchedule(employeeId);
    await loadScheduleSettings(employeeId);

    final balance = await leaveService.getLeaveBalance(employeeId);

    if (balance != null) {
      leaveBalanceDays.value =
          (balance['annual_leave'] ?? 0) +
          (balance['sick_leave'] ?? 0) +
          (balance['casual_leave'] ?? 0);
    }
  }

  Future<void> loadScheduleSettings(String employeeId) async {
    final schedule = await scheduleService.getScheduleSettings(employeeId);

    if (schedule != null) {
      expectedWorkHours.value =
          (schedule['expected_work_hours'] as num?)?.toDouble() ?? 8.0;

      breakAllowanceHours.value =
          (schedule['break_allowance_hours'] as num?)?.toDouble() ?? 1.0;
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

  Future<void> loadHolidays({bool refresh = false}) async {
    if (isLoadingHolidays.value) return;

    isLoadingHolidays.value = true;

    try {
      if (refresh) {
        holidayPage.value = 0;
        hasMoreHolidays.value = true;
        holidays.clear();
      }

      if (!hasMoreHolidays.value) return;

      final data = await dashboardService.getUpcomingHolidays(
        page: holidayPage.value,
        limit: holidayPageSize,
      );

      holidays.addAll(data);

      if (data.length < holidayPageSize) {
        hasMoreHolidays.value = false;
      } else {
        holidayPage.value++;
      }
    } finally {
      isLoadingHolidays.value = false;
    }
  }

  Future<void> loadMoreHolidays() async {
    await loadHolidays();
  }

  Future<void> resetHolidays() async {
    holidayPage.value = 0;
    hasMoreHolidays.value = true;
    holidays.clear();

    await loadHolidays(refresh: true);
  }

  Future<void> loadEmployeeActivities({bool refresh = false}) async {
    if (isLoadingEmployeeActivities.value) return;

    isLoadingEmployeeActivities.value = true;

    try {
      if (refresh) {
        employeeActivityPage.value = 0;
        hasMoreEmployeeActivities.value = true;
        employeeActivities.clear();
      }

      if (!hasMoreEmployeeActivities.value) return;

      final data = await dashboardService.getRecentEmployeeActivities(
        page: employeeActivityPage.value,
        limit: employeeActivityPageSize,
      );

      employeeActivities.addAll(data);

      if (data.length < employeeActivityPageSize) {
        hasMoreEmployeeActivities.value = false;
      } else {
        employeeActivityPage.value++;
      }
    } finally {
      isLoadingEmployeeActivities.value = false;
    }
  }
}
