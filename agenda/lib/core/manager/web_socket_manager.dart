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
          print('Connecting to WebSocket...');
        },
        stompConnectHeaders: {
          'Authorization': "Bearer $jwtToken",
        },
        onWebSocketError: (dynamic error) => print('Error: $error'),
      ),
    );

    stompClient.activate();
  }

  void onConnect(StompFrame frame) {
    print('Connected to WebSocket');

    stompClient.subscribe(
      destination: StringConstants.webSocketDestination,
      callback: (frame) {
        try {
          if (frame.body != null) {
            print('Notification received: ${frame.body}');
            final notificationMap = jsonDecode(frame.body!) as Map<String, dynamic>;
            final notification = NotificationModel.fromJson(notificationMap);
            _showBrowserNotification(notification);
          }
        } catch (e) {
          print('Error handling notification: $e');
        }
      },
    );
  }

  void disconnect() {
    stompClient?.deactivate();
    print('Disconnected from WebSocket');
  }

  void _showBrowserNotification(NotificationModel notification) {
    if (Notification.supported) {
      Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          Notification(notification.title, body: notification.message);
        }
      });
    } else {
      print("Notifications not supported");
    }
  }
}