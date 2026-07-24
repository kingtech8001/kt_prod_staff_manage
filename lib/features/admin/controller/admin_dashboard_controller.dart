import 'package:get/get.dart';
import '../../../core/services/dashboard_service.dart';
import 'activity_paging_controller.dart';

enum ActivityViewType { employee, hr }

class AdminDashboardController extends GetxController {
  final dashboardService = DashboardService();
  final selectedActivityView = ActivityViewType.employee.obs;

  final employeeActivities = <Map<String, dynamic>>[].obs;
  final hrActivities = <Map<String, dynamic>>[].obs;

  late final ActivityPagingController employeePaging;
  late final ActivityPagingController hrPaging;

  final totalEmployees = 0.obs;
  final totalHrManagers = 0.obs;
  final presentToday = 0.obs;
  final pendingLeaves = 0.obs;

  @override
  void onInit() {
    super.onInit();

    employeePaging = Get.put(
      ActivityPagingController(role: 'Employee'),
      tag: 'employee',
    );

    hrPaging = Get.put(ActivityPagingController(role: 'HR'), tag: 'hr');

    Future(() async {
      await loadDashboardStats();
      await loadRecentDashboardActivities();
    });
  }

  Future<void> loadRecentDashboardActivities() async {
    employeeActivities.value = await dashboardService
        .getRecentEmployeeActivities(role: 'Employee', page: 0, limit: 3);

    hrActivities.value = await dashboardService.getRecentEmployeeActivities(
      role: 'HR',
      page: 0,
      limit: 3,
    );
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
