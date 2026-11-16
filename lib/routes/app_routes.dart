import 'package:get/get.dart';

import '../views/login_page.dart';
import '../views/register_page.dart';
import '../views/dashboard_page.dart';
import '../views/main_navigation_page.dart';
import '../views/account_page.dart';
import '../binding/account_binding.dart';
import '../binding/dashboard_binding.dart'; // Import binding-nya

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const main = '/main';
  static const account = '/account';

  static final pages = [
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: register, page: () => const RegisterPage()),
    GetPage(
      name: dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(), // Tambahkan baris ini
    ),
    GetPage(
      name: main,
      page: () => const MainNavigationPage(),
      bindings: [DashboardBinding(), AccountBinding()],
    ),
    GetPage(
      name: account,
      page: () => const AccountPage(),
      binding: AccountBinding(),
    ),
  ];
}
