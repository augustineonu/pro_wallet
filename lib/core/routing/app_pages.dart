import 'package:get/get.dart';
import 'package:pro_wallet/modules/auth/views/login_view.dart';
import 'package:pro_wallet/modules/auth/views/signup_view.dart';
import 'package:pro_wallet/modules/dashboard/views/dashboard_view.dart';
import 'package:pro_wallet/modules/history/views/history_view.dart';
import 'package:pro_wallet/modules/home/views/home_view.dart';
import 'package:pro_wallet/modules/profile/views/profile_view.dart';

// part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginViewBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => SignupView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      binding: HomeviewBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      binding: HomeviewBinding(),
    ),
    GetPage(
      name: Routes.history,
      page: () => HistoryView(),
      binding: HistoryViewBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfileView(),
      // binding: HistoryViewBinding(),
    ),
  ];
}

// app_routes.dart (part of app_pages.dart)
// part of 'app_pages.dart';

abstract class Routes {
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const DASHBOARD = '/dashboard';
  static const home = '/home';
  static const profile = '/profile';
  static const history = '/history';
}