import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:html';
import '../costants/string_constants.dart';
import '../data/models/notification_model/notification_model.dart';
import '../utils/logger.dart';

class WebSocketManager {
  late StompClient stompClient;
  bool _isConnected = false;

  void connect(String jwtToken, String url) {
    if (_isConnected) {
      Logger.log('WebSocket connection already established');
    } else {
      stompClient = StompClient(
        config: StompConfig.sockJS(
          url: url,
          onConnect: onConnect,
          beforeConnect: () async {
            Logger.log('Connecting to WebSocket...');
          },
          stompConnectHeaders: {
            'Authorization': "Bearer $jwtToken",
          },
          onWebSocketError: (dynamic error) => print('Error: $error'),
        ),
      );

      stompClient.activate();
      _isConnected = true;
    }
  }

  void onConnect(StompFrame frame) {
    Logger.log('Connected to WebSocket');

    stompClient.subscribe(
      destination: StringConstants.webSocketDestination,
      callback: (frame) {
        try {
          if (frame.body != null) {
            Logger.log('Notification received: ${frame.body}');
            final notificationMap =
                jsonDecode(frame.body!) as Map<String, dynamic>;
            final notification = NotificationModel.fromJson(notificationMap);
            _showBrowserNotification(notification);
          }
        } catch (e) {
          Logger.logException(e);
        }
      },
    );
  }

  void disconnect() {
    if (!_isConnected) {
      Logger.log('No WebSocket connection to disconnect');
    } else {
      stompClient.deactivate();
      _isConnected = false;
      Logger.log('Disconnected from WebSocket');
    }
  }

  void _showBrowserNotification(NotificationModel notification) {
    if (Notification.supported) {
      Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          Notification(notification.title, body: notification.message);
        }
      });
    } else {
      Logger.log("Notifications not supported");
    }
  }
}
