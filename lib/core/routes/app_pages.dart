import 'package:get/get.dart';

import '../../features/auth/screens/login_view.dart';
import '../../features/auth/screens/splash_view.dart';
import '../../features/employee/view/employee_layout_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.employee, page: () => EmployeeLayoutView()),
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
  ];
}
