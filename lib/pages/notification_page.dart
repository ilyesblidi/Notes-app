import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/main.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {

    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage?;

    return Scaffold(
      appBar: AppBar(
        // i want when the user click on return button it will take him to the home page
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     navigatorKey.currentState?.pushNamed(
        //       '/home_page',
        //       arguments: message,
        //     );
        //   },
        // ),
        title: const Text('Notifications', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF2F1859), // Dark purple color
      ),

      body: Center(
        child: (message != null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Title: ${message.notification?.title.toString()}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Body: ${message.notification?.body.toString()}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              )
            :
        Text(
          'No notifications yet!',
          style: TextStyle(fontSize: 24),
        ),
      ),

    );
  }
}
