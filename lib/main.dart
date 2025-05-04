import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app/api/firebase_api.dart';
import 'package:notes_app/firebase_options.dart';
import 'package:notes_app/pages/favNote_page.dart';
import 'package:notes_app/pages/home_page.dart';
import 'package:notes_app/pages/notification_page.dart';
import 'package:notes_app/pages/parameters_page.dart';
import 'package:notes_app/pages/welcome_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await FirebaseApi().initNotifications() ;

    runApp( MyApp() );
  }

  class MyApp extends StatelessWidget {


    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        routes: {
          '/welcome_page': (context) => const WelcomePage(),
          // Add other routes here
          '/notification_page': (context) => const NotificationPage(),
          '/parameters_page': (context) => const ParametersPage(),
          '/favNote_page': (context) => const FavoritesPage(),
          '/home_page': (context) => const HomePage(),

        },
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomePage(),
      );
    }
  }