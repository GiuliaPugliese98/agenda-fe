import "package:agenda/calendar/screen/calendar_screen.dart";
import "package:agenda/calendar/state/calendar_cubit.dart";
import "package:agenda/core/ui/app_routes/routes_constants.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get/get.dart";
import "package:get/get_core/src/get_main.dart";
import "../../../login/ui/screen/login_screen.dart";
import "../../../login/ui/state/login_cubit.dart";
import "../../../pre_login/screen/pre_login_screen.dart";
import "../../../pre_login/state/pre_login_cubit.dart";
import "../../../registration/screen/registration_screen.dart";
import "../../../registration/state/registration_cubit.dart";
import "../../../splash/ui/screen/splash_screen.dart";
import "../../../splash/ui/state/splash_cubit.dart";
import "../../data/repository/user_repository.dart";
import "../widgets/alert_dialog/cubit/alert_dialog_cubit.dart";
import "../widgets/thank_you_page/state/thank_you_page_cubit.dart";

class AppRoutes {
  static GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: 'AppRoutes');

  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _buildRoute(
          BlocProvider(
            create: (_) => SplashCubit(),
            child: SplashPage(),
          ),
          settings,
        );
      case Routes.preLogin:
        return _buildRoute(
          BlocProvider(
            create: (_) => PreLoginCubit(),
            child: PreLogin(),
          ),
          settings,
        );
      case Routes.login:
        return _buildRoute(
          BlocProvider(
            create: (_) => LoginCubit(),
            child: Login(),
          ),
          settings,
        );
      case Routes.registration:
        return _buildRoute(
          BlocProvider(
            create: (_) =>
                RegistrationCubit(Get.find<UserRepository>(), Get.arguments),
            child: Registration(),
          ),
          settings,
        );
      case Routes.calendar:
        return _buildRoute(
          BlocProvider(
            create: (_) => CalendarCubit(),
            child: Calendar(),
          ),
          settings,
        );
      default:
        return null;
    }
  }

  static Route _buildRoute(Widget child, RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => child,
    );
  }

  static Future<T?> pushNamed<T>(String route, {Object? arguments}) async {
    return await navigatorKey.currentState!
        .pushNamed(route, arguments: arguments);
  }

  static Future<T?> showThankYouPage<T>(Widget child) async {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => showTYPOnBuildCompleted(child));
  }

  static Future<T?> showCustomDialog<T>(Widget child,
      {bool enableBackButton = false}) async {
    return await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (_) => AlertDialogCubit(),
          child: PopScope(
            canPop: enableBackButton,
            onPopInvoked: (didPop) {},
            child: child,
          ),
        );
      },
    );
  }

  static void popUntil<T>(String destination, {T? result}) {
    return navigatorKey.currentState!
        .popUntil((route) => route.settings.name == destination);
  }

  static Future showTYPOnBuildCompleted(Widget child) async {
    return await showDialog(
      context: Get.context!,
      barrierColor: Colors.white,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (_) => ThankYouPageCubit(),
          child: child,
        );
      },
    );
  }

  static Future popUntilPrelogin() async {
    return await navigatorKey.currentState!
        .pushNamedAndRemoveUntil(Routes.preLogin, (route) => false);
  }
}
