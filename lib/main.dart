import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_wallet/app_theme.dart';
import 'package:pro_wallet/core/app_binding/app_bindings.dart';
import 'package:pro_wallet/core/routing/app_pages.dart';
import 'package:pro_wallet/data/service/firebase_service.dart';
import 'package:pro_wallet/modules/auth/controllers/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize global controllers
  await Get.putAsync(() => FirebaseService().init());
  // Get.put(AuthController(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wallet App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.INITIAL,
      navigatorKey: _navKey,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
      initialBinding: AppBindings(),
    );
  }
}
