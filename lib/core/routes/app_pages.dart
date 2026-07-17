import 'package:get/get.dart';
import '../../features/auth/screens/login_view.dart';
import '../../features/auth/screens/splash_view.dart';
import '../../shared/dashboard/dashboard_layout.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.dashboard, page: () => DashboardLayout()),

    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
  ];
}
