import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notes_app/main.dart';

class FirebaseApi {
  // create an instance of FirebaseMessaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Function to initialize notifications

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    // get token
    final token = await _firebaseMessaging.getToken();

    if (token != null) {
      print('FCM Token: $token');
    } else {
      print('Failed to get FCM token');
    }

    initPushNotifications();

  }

  // Function to handle received messages

  void handleMessages( RemoteMessage? message ) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      '/notification_page',
      arguments: message,
    );
  }

  // Function to initialize background settings

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessages);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
  }

}