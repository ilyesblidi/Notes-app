import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/main.dart';

// Global list to store notifications
final List<RemoteMessage> globalNotifications = [];

// Global map to track clicked notifications
final Map<int, bool> clickedNotifications = {};

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if a notification opened the app
    final message =
        ModalRoute.of(context)?.settings.arguments as RemoteMessage?;
    if (message != null && !_isNotificationAlreadyAdded(message)) {
      setState(() {
        globalNotifications.add(message);
      });
    }
  }

  // Helper method to check if a notification is already in the list
  bool _isNotificationAlreadyAdded(RemoteMessage message) {
    return globalNotifications.any(
      (notification) => notification.messageId == message.messageId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2F1859), // Dark purple color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () {
            navigatorKey.currentState?.pushNamed('/home_page');
          },
        ),
      ),
      body:
          globalNotifications.isEmpty
              ? const Center(
                child: Text(
                  'No notifications yet!',
                  style: TextStyle(fontSize: 24),
                ),
              )
              : ListView.builder(
                itemCount: globalNotifications.length,
                itemBuilder: (context, index) {
                  final notification = globalNotifications[index];

                  return ListTile(
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          globalNotifications.removeAt(index);
                          clickedNotifications.remove(
                            index,
                          ); // Remove from clicked map if deleted
                        });
                      },
                    ),
                    contentPadding: const EdgeInsets.all(8.0),
                    tileColor: Colors.white,
                    title: Text(
                      notification.notification?.title ?? 'No Title',
                      style: TextStyle(
                        fontWeight:
                            clickedNotifications[index] == true
                                ? FontWeight.normal
                                : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      notification.notification?.body ?? 'No Body',
                      style: TextStyle(
                        fontWeight:
                            clickedNotifications[index] == true
                                ? FontWeight.normal
                                : FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        clickedNotifications[index] = true; // Mark as clicked
                      });
                    },
                  );
                },
              ),
    );
  }
}
