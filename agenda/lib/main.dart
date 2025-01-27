import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/ui/app_routes/routes.dart';
import 'dependency_injection.dart';
import 'login/ui/user_controller.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  initDependencies();
  Get.put(UserController());
  setUrlStrategy(PathUrlStrategy());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
      ),
      routerConfig: AppRoutes.router,
    );
  }
}