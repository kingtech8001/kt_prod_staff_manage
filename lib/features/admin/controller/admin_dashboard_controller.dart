import 'package:get/get.dart';
import '../../../core/services/dashboard_service.dart';

enum ActivityViewType { employee, hr }

class AdminDashboardController extends GetxController {
  final dashboardService = DashboardService();

  final selectedActivityView = ActivityViewType.employee.obs;

  final totalEmployees = 0.obs;
  final totalHrManagers = 0.obs;
  final presentToday = 0.obs;
  final pendingLeaves = 0.obs;

  static const int employeeActivityPageSize = 5;
  final employeeActivities = <Map<String, dynamic>>[].obs;
  final hrActivities = <Map<String, dynamic>>[].obs;
  final employeeActivityPage = 0.obs;
  final hasMoreEmployeeActivities = true.obs;
  final isLoadingEmployeeActivities = false.obs;

  @override
  void onInit() {
    super.onInit();

    Future(() async {
      await loadDashboardStats();

      await loadEmployeeActivities(refresh: true, role: 'Employee');

      await loadHrActivities(refresh: true);
    });
  }

  Future<void> loadEmployeeActivities({
    required String role,
    bool refresh = false,
  }) async {
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
        role: role,
        page: employeeActivityPage.value,
        limit: employeeActivityPageSize,
      );

      if (isClosed) return;

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

  Future<void> loadHrActivities({bool refresh = false}) async {
    if (isLoadingEmployeeActivities.value) return;

    isLoadingEmployeeActivities.value = true;

    try {
      if (refresh) {
        employeeActivityPage.value = 0;
        hasMoreEmployeeActivities.value = true;
        hrActivities.clear();
      }

      if (!hasMoreEmployeeActivities.value) return;

      final data = await dashboardService.getRecentEmployeeActivities(
        role: 'HR',
        page: employeeActivityPage.value,
        limit: employeeActivityPageSize,
      );

      if (isClosed) return;

      hrActivities.addAll(data);

      if (data.length < employeeActivityPageSize) {
        hasMoreEmployeeActivities.value = false;
      } else {
        employeeActivityPage.value++;
      }
    } finally {
      isLoadingEmployeeActivities.value = false;
    }
  }

  Future<void> loadDashboardStats() async {
    totalEmployees.value = await dashboardService.getEmployeeCount();
    totalHrManagers.value = await dashboardService.getHrCount();
    presentToday.value = await dashboardService.getPresentTodayCount();
    pendingLeaves.value = await dashboardService.getPendingLeaveCount();
  }

  void openEmployeeActivities() {
    selectedActivityView.value = ActivityViewType.employee;
  }

  void openHrActivities() {
    selectedActivityView.value = ActivityViewType.hr;
  }
}
