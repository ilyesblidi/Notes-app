import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  final bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// INITIALIZE

  Future<void> initialize() async {
    if (_isInitialized) return;
    // Initialize the notification service
    // This is where you would set up your notification channels, etc.
    // For example, using Firebase Messaging:
    // await FirebaseMessaging.instance.requestPermission();

    /// prepare android init settings
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    /// prepare ios init settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    /// initialize settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    /// finally initialize the plugin
    await notificationsPlugin.initialize(initSettings);

  }

  /// NOTIFICATIONS DETAIAL SETUP

  NotificationDetails notificationDetails() {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
  }

  /// SHOW NOTIFICATION

  Future<void> showNotification({int id = 0, String? title, String? body}) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(),
    );
  }

}