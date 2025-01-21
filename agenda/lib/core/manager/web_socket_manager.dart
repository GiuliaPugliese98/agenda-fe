import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:html';
import '../costants/string_constants.dart';
import '../data/models/notification_model/notification_model.dart';

class WebSocketManager {
  late StompClient stompClient;

  void connect(String jwtToken, String url) {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: url,
        onConnect: onConnect,
        beforeConnect: () async {
          print('Connessione al WebSocket...');
        },
        stompConnectHeaders: {
          'Authorization': "Bearer $jwtToken",
        },
        onWebSocketError: (dynamic error) => print('Errore: $error'),
      ),
    );

    stompClient.activate();
  }

  void onConnect(StompFrame frame) {
    print('Connesso al WebSocket');

    stompClient.subscribe(
      destination: StringConstants.webSocketDestination,
      callback: (frame) {
        try {
          if (frame.body != null) {
            print('Notifica ricevuta: ${frame.body}');
            final notificationMap = jsonDecode(frame.body!) as Map<String, dynamic>;
            final notification = NotificationModel.fromJson(notificationMap);
            _showBrowserNotification(notification);
          }
        } catch (e) {
          print('Errore nella gestione della notifica: $e');
        }
      },
    );
  }

  void disconnect() {
    stompClient?.deactivate();
    print('Disconnesso dal WebSocket');
  }

  void _showBrowserNotification(NotificationModel notification) {
    if (Notification.supported) {
      Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          Notification(notification.title, body: notification.message);
        } else {
          print("Permesso per notifiche negato.");
        }
      });
    } else {
      print("Le notifiche del browser non sono supportate.");
    }
  }
}