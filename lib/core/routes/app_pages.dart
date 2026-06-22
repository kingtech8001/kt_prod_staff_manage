import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/hr/view/hr_layout_view.dart';

import '../../features/admin/view/admin_layout_view.dart';
import '../../features/auth/screens/login_view.dart';
import '../../features/auth/screens/splash_view.dart';
import '../../features/employee/view/employee_layout_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.employee, page: () => EmployeeLayoutView()),
    GetPage(name: AppRoutes.hr, page: () => HrLayoutView()),
    GetPage(name: AppRoutes.admin, page: () => AdminLayoutView()),

    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
  ];
}
