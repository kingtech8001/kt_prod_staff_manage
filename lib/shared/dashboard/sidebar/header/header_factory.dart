import 'dashboard_header.dart';
import 'employee_search_widget.dart';
import 'hr_search_widget.dart';
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
        actionWidget: EmployeeSearchWidget(),
        showNotification: true,
      ),
    );
  }

  static DashboardHeader admin() {
    return DashboardHeader(
      config: HeaderConfig(
        actionWidget: HrSearchWidget(),
        showNotification: false,
      ),
    );
  }
}
