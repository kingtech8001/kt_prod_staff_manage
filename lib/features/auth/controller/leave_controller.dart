import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../core/services/leave_service.dart';

class LeaveController extends GetxController {
  final service = LeaveService();

  final leaveList = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final leaveBalance = Rxn<Map<String, dynamic>>();
  @override
  void onInit() {
    super.onInit();

    final authController = Get.find<AuthController>();

    // React to user changes (login, refresh, session restore)
    ever(authController.currentUser, (user) {
      if (user != null) {
        loadLeaves(user.id);
      } else {
        leaveList.clear();
      }
    });

    // Load immediately if user already exists
    if (authController.user != null) {
      loadLeaves(authController.user!.id);
    }
  }

  Future<void> loadLeaves(String employeeId) async {
    try {
      isLoading.value = true;

      final leaves = await service.getLeaves(employeeId);

      final balance = await service.getLeaveBalance(employeeId);

      leaveList.value = leaves;

      leaveBalance.value = balance;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyLeave({
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    final user = Get.find<AuthController>().user;

    if (user == null) return;

    try {
      await service.applyLeave(
        employeeId: user.id,
        leaveType: leaveType,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
      );

      await loadLeaves(user.id);

      Get.snackbar('Success', 'Leave request submitted successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
