import 'package:get/get.dart';
import '../../../../features/admin/controller/hr_directory_controller.dart';
import '../../../../features/hr/controller/employee_directory_controller.dart';
import '../../search/search_widget.dart';
import '../../search/tiles/admin_search_tile.dart';
import '../../search/tiles/employee_search_tile.dart';
import 'dashboard_header.dart';
import 'leave_request_button.dart';
import 'header_config.dart';

class HeaderFactory {
  const HeaderFactory._();

  static DashboardHeader employee() {
    return DashboardHeader(
      config: HeaderConfig(
        actionWidget: LeaveRequestButton(),
        showNotification: true,
      ),
    );
  }

  static DashboardHeader hr() {
    return DashboardHeader(
      config: HeaderConfig(
        actionWidget: SearchWidget(
          controller: Get.find<EmployeeDirectoryController>(),
          hintText: 'Search employees...',
          loadingTitle: 'Searching employees',
          loadingSubtitle: 'Looking for matching employees...',
          emptyTitle: 'No employees found',
          emptySubtitle: 'Try another name, employee ID or designation.',
          itemBuilder: (context, employee, onTap) {
            return EmployeeSearchTile(employee: employee, onTap: onTap);
          },
        ),
        showNotification: true,
      ),
    );
  }

  static DashboardHeader admin() {
    return DashboardHeader(
      config: HeaderConfig(
        actionWidget: SearchWidget(
          controller: Get.find<HrDirectoryController>(),
          hintText: 'Search HR & Employees...',
          loadingTitle: 'Searching staff',
          loadingSubtitle: 'Looking for matching staff...',
          emptyTitle: 'No staff found',
          emptySubtitle: 'Try another name, employee ID or designation.',
          itemBuilder: (context, user, onTap) {
            return AdminSearchTile(user: user, onTap: onTap);
          },
        ),
        showNotification: false,
      ),
    );
  }
}
