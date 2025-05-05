import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final _emailController = TextEditingController();

  void passwordReset() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());

      showDialog(context: context, builder: (contexte) {
        return AlertDialog(
          content: Text('Password reset link sent! Check your email'),
        );
      });

    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(context: context, builder: (contexte) {
      return AlertDialog( 
          content: Text(e.message.toString()),
      );
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[200],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          Text('Please enter your email address and we will send you a link to reset your password',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          )),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10 ,vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.deepPurple , width: 2),
                borderRadius: BorderRadius.circular(15),
              ),

              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email',
                  icon: Icon(Icons.email),
                ), ),
            ),
          ),

          MaterialButton(onPressed: passwordReset ,

          color: Colors.brown[300],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Reset Password', style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),
          ),
          ),

        ],),
      ),
    );
  }
}
