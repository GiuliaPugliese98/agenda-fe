import 'package:flutter/material.dart';

import '../../../main.dart';

// Variabile globale per tracciare la route corrente
String? currentRouteName;

mixin RouteAwareMixin<T> implements RouteAware {
  void subscribeToRoute(BuildContext context) {
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute<dynamic>) {
      // Registra la route nel RouteObserver
      routeObserver.subscribe(this, modalRoute);

      // Memorizza il nome della route corrente
      currentRouteName = modalRoute.settings.name;
      print('Route corrente: $currentRouteName');
    }
  }

  void unsubscribeFromRoute() {
    routeObserver.unsubscribe(this);
    currentRouteName = null; // Resetta la route corrente
  }

  @override
  void didPush() {
    // Aggiorna il nome della route corrente
    currentRouteName = T.toString(); // Nome della classe
    print("didPush chiamato su $currentRouteName");
  }

  @override
  void didPop() {
    // Resetta la route corrente quando viene poppata
    currentRouteName = null;
    print("didPop chiamato su $T");
  }

  @override
  void didPopNext() {
    print("didPopNext chiamato su $T");
  }

  @override
  void didPushNext() {
    print("didPushNext chiamato su $T");
  }
}