import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'package:notes_app/firebase_options.dart';
  import 'package:notes_app/pages/welcome_page.dart';

  final Client client = Client();

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Initialize Appwrite Client
    client.setEndpoint('https://fra.cloud.appwrite.io/v1') // Your Appwrite Endpoint
        .setProject('68109a3900149fa4e09b') // Your project ID
        .setSelfSigned(status: true); // Use only on dev mode with a self-signed certificate

    runApp( MyApp(client) );
  }

  class MyApp extends StatelessWidget {

    final Client client;

    const MyApp( this.client, {super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomePage(),
      );
    }
  }