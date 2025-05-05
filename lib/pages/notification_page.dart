import 'package:firebase_messaging/firebase_messaging.dart';
    import 'package:flutter/material.dart';
    import 'package:notes_app/main.dart';

    final List<RemoteMessage> globalNotifications = [];
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
        final message =
            ModalRoute.of(context)?.settings.arguments as RemoteMessage?;
        if (message != null && !_isNotificationAlreadyAdded(message)) {
          setState(() {
            globalNotifications.add(message);
          });
        }
      }

      bool _isNotificationAlreadyAdded(RemoteMessage message) {
        return globalNotifications.any(
          (notification) => notification.messageId == message.messageId,
        );
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          navigatorKey.currentState?.pushNamed('/main_page');
                        },
                          child: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white,)),
                    ],
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: globalNotifications.isEmpty
                      ? const Center(
                          child: Text(
                            'No notifications yet!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: globalNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = globalNotifications[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                title: Text(
                                  notification.notification?.title ?? 'No Title',
                                  style: TextStyle(
                                    fontWeight: clickedNotifications[index] == true
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  notification.notification?.body ?? 'No Body',
                                  style: TextStyle(
                                    fontWeight: clickedNotifications[index] == true
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      globalNotifications.removeAt(index);
                                      clickedNotifications.remove(index);
                                    });
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    clickedNotifications[index] = true;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      }
    }