import 'package:get/get.dart';

import '../repository/hr_repository.dart';

class OperationsController extends GetxController {
  final repository = HrRepository();
  static const int pendingLeavePageSize = 5;
  final pendingLeaves = <Map<String, dynamic>>[].obs;
  final pendingLeavePage = 0.obs;
  final hasMorePendingLeaves = true.obs;
  final isLoadingPendingLeaves = false.obs;

  static const int liveActivityPageSize = 5;
  final liveActivities = <Map<String, dynamic>>[].obs;
  final liveActivityPage = 0.obs;
  final hasMoreLiveActivities = true.obs;
  final isLoadingLiveActivities = false.obs;

  @override
  void onInit() {
    super.onInit();

    loadPendingLeaves(refresh: true);
    loadLiveActivities(refresh: true);
  }

  Future<void> loadPendingLeaves({bool refresh = false}) async {
    if (isLoadingPendingLeaves.value) return;

    isLoadingPendingLeaves.value = true;

    try {
      if (refresh) {
        pendingLeavePage.value = 0;
        hasMorePendingLeaves.value = true;
        pendingLeaves.clear();
      }

      if (!hasMorePendingLeaves.value) return;

      final data = await repository.getPendingLeaveRequests(
        page: pendingLeavePage.value,
        limit: pendingLeavePageSize,
      );

      pendingLeaves.addAll(data);

      if (data.length < pendingLeavePageSize) {
        hasMorePendingLeaves.value = false;
      } else {
        pendingLeavePage.value++;
      }
    } finally {
      isLoadingPendingLeaves.value = false;
    }
  }

  Future<void> loadMorePendingLeaves() async {
    await loadPendingLeaves();
  }

  Future<void> resetPendingLeaves() async {
    await loadPendingLeaves(refresh: true);
  }

  Future<void> loadLiveActivities({bool refresh = false}) async {
    if (isLoadingLiveActivities.value) return;

    isLoadingLiveActivities.value = true;

    try {
      if (refresh) {
        liveActivityPage.value = 0;
        hasMoreLiveActivities.value = true;
        liveActivities.clear();
      }

      if (!hasMoreLiveActivities.value) return;

      final data = await repository.getLiveActivities(
        page: liveActivityPage.value,
        limit: liveActivityPageSize,
      );

      liveActivities.addAll(data);

      if (data.length < liveActivityPageSize) {
        hasMoreLiveActivities.value = false;
      } else {
        liveActivityPage.value++;
      }
    } finally {
      isLoadingLiveActivities.value = false;
    }
  }

  Future<void> loadMoreLiveActivities() async {
    await loadLiveActivities();
  }

  Future<void> resetLiveActivities() async {
    await loadLiveActivities(refresh: true);
  }
}
