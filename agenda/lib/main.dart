import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/ui/app_routes/routes.dart';
import 'dependency_injection.dart';
import 'login/ui/user_controller.dart';

void main() {
  initDependencies(); // Inizializza le dipendenze
  Get.put(UserController()); // Inizializza il controller utente
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
      ),
      navigatorKey: AppRoutes.navigatorKey,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}