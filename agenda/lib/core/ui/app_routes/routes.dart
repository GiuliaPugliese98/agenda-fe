import 'package:agenda/core/ui/app_routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agenda/splash/ui/screen/splash_screen.dart';
import 'package:agenda/pre_login/screen/pre_login_screen.dart';
import 'package:agenda/login/ui/screen/login_screen.dart';
import 'package:agenda/registration/screen/registration_screen.dart';
import 'package:agenda/calendar/screen/calendar_screen.dart';
import 'package:agenda/add_event/screen/add_event_screen.dart';
import 'package:agenda/event_details/screen/event_details_screen.dart';
import 'package:agenda/event_details/state/event_details_cubit.dart';
import 'package:agenda/splash/ui/state/splash_cubit.dart';
import 'package:agenda/pre_login/state/pre_login_cubit.dart';
import 'package:agenda/login/ui/state/login_cubit.dart';
import 'package:agenda/registration/state/registration_cubit.dart';
import 'package:agenda/calendar/state/calendar_cubit.dart';
import 'package:agenda/add_event/state/add_event_cubit.dart';
import '../widgets/alert_dialog/cubit/alert_dialog_cubit.dart';
import '../widgets/thank_you_page/state/thank_you_page_cubit.dart';

class AppRoutes {
  static GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: 'AppRoutes');

  static GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        name: Routes.splash,
        path: Routes.splash,
        builder: (context, state) => BlocProvider(
          create: (_) => SplashCubit(),
          child: SplashPage(),
        ),
      ),
      GoRoute(
        name: Routes.preLogin,
        path: Routes.preLogin,
        builder: (context, state) => BlocProvider(
          create: (_) => PreLoginCubit(),
          child: PreLogin(),
        ),
      ),
      GoRoute(
        name: Routes.login,
        path: Routes.login,
        builder: (context, state) => BlocProvider(
          create: (_) => LoginCubit(),
          child: Login(),
        ),
      ),
      GoRoute(
        name: Routes.registration,
        path: Routes.registration,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return BlocProvider(
            create: (_) =>
                RegistrationCubit(args?['repository'], args?['arguments']),
            child: Registration(),
          );
        },
      ),
      GoRoute(
        name: Routes.calendar,
        path: '${Routes.calendar}/:month/:year',
        builder: (context, state) {
          int month = int.parse(state.pathParameters['month']!);
          int year = int.parse(state.pathParameters['year']!);
          return BlocProvider(
            create: (_) => CalendarCubit(month, year),
            child: Calendar(month, year),
          );
        },
      ),
      GoRoute(
        name: Routes.addEvent,
        path: Routes.addEvent,
        builder: (context, state) => BlocProvider(
          create: (_) => AddEventCubit(),
          child: AddEvent(),
        ),
      ),
      GoRoute(
        name: Routes.eventDetail,
        path: '${Routes.eventDetail}/:uuid',
        builder: (context, state) {
          String? uuid = state.pathParameters['uuid'];
          return BlocProvider(
            create: (_) => EventDetailsCubit(uuid!),
            child: EventDetails(uuid!),
          );
        },
      ),
    ],
  );

  static void pushNamed(String route, {Map<String, String>? pathParameters}) {
    if (pathParameters != null) {
      router.pushNamed(route, pathParameters: pathParameters);
    } else {
      router.pushNamed(route);
    }
  }

  static Future<T?> showThankYouPage<T>(
      BuildContext context, Widget child) async {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => showTYPOnBuildCompleted(context, child));
  }

  static Future<T?> showCustomDialog<T>(
    BuildContext context,
    Widget child, {
    bool enableBackButton = false,
  }) async {
    return await showDialog(
      context: context, // Use context as argument
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
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

  static Future showTYPOnBuildCompleted(
      BuildContext context, Widget child) async {
    return await showDialog(
      context: context,
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

  static Future<void> popUntilPrelogin() async {
    router.go(Routes.preLogin);
  }
}
