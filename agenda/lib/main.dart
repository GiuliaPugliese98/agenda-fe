import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/ui/app_routes/route_aware_mixin.dart';
import 'core/ui/app_routes/routes.dart';
import 'dependency_injection.dart';
import 'login/ui/user_controller.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:html' as html;

// RouteObserver globale
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  initDependencies(); // Inizializza le dipendenze
  Get.put(UserController()); // Inizializza il controller utente
  setUrlStrategy(PathUrlStrategy()); //Elimina il cancelletto dagli url

  // Intercetta la ricarica del browser
  html.window.onBeforeUnload.listen((event) {
    if (currentRouteName != null) {
      // Ricarica la pagina con la route corrente
      AppRoutes.navigatorKey.currentState?.pushReplacementNamed(currentRouteName!);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
      ),
      navigatorKey: AppRoutes.navigatorKey,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}