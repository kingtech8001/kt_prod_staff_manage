import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../core/services/dashboard_service.dart';

class ActivityPagingController extends GetxController {
  ActivityPagingController({required this.role});

  final String role;

  final DashboardService _dashboardService = DashboardService();

  static const int pageSize = 5;

  late final PagingController<int, Map<String, dynamic>> pagingController =
      PagingController<int, Map<String, dynamic>>(
        getNextPageKey: (state) {
          return state.lastPageIsEmpty ? null : state.nextIntPageKey;
        },

        fetchPage: (pageKey) async {
          return await _dashboardService.getRecentEmployeeActivities(
            role: role,
            page: pageKey - 1,
            limit: pageSize,
          );
        },
      );

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
