import 'package:firebase_auth/firebase_auth.dart';
import '../pages/welcome_page.dart';
import 'auth_page.dart';
import 'package:flutter/material.dart';


class ControlPage extends StatelessWidget {
  const ControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges() ,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if(snapshot.hasError){
              return const Center(
                child: Text('Something went wrong'),
              );
            } else if(snapshot.hasData){
              return const WelcomePage();
            } else {
              return AuthPage();
            }
          }
      ),
    );
  }
}
