import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app/Auth/auth_page.dart';
import 'package:notes_app/Auth/control_page.dart';
import 'package:notes_app/api/firebase_api.dart';
import 'package:notes_app/firebase_options.dart';
import 'package:notes_app/pages/favorites_page.dart';
import 'package:notes_app/pages/home_page.dart';
import 'package:notes_app/pages/main_page.dart';
import 'package:notes_app/pages/notification_page.dart';
import 'package:notes_app/pages/parameters_page.dart';
import 'package:notes_app/pages/welcome_page.dart';
import 'package:notes_app/services/noti_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await FirebaseApi().initNotifications() ;

    // initNotifications
    NotiService().initialize();

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
          '/auth_page': (context) => AuthPage(),
          '/login_page': (context) => const ControlPage(),
          '/register_page': (context) => const ControlPage(),
          '/main_page': (context) => const MainPage(),

        },
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ControlPage(),
      );
    }
  }