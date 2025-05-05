import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'forgot_pw_page.dart';


class LoginPage extends StatefulWidget {

  final VoidCallback showRegisterPage;

  LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future singIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if(email.isEmpty || password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all the fields'),
          backgroundColor: Colors.red,
        )
      );
      return;
    }

    try {

      ///adding a circular progress indicator
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email , password: password);

      ///removing the circular progress indicator
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in successful'),
          backgroundColor: Colors.green,
        )
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in failed: $e'),
          backgroundColor: Colors.red,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

              SizedBox(height: MediaQuery.of(context).size.height * 0.2),

              Icon(Icons.android , size: 80,),
                
              Text('Hello again!', style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),),
          
              SizedBox(height: 10,),
          
              Text('Welcome back, you\'ve been missed', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
          
                SizedBox(height: 20,),
          
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
                      icon: Icon(Icons.person),
                    ), ),
                  ),
                ),
          
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10 ,vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.deepPurple, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
          
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      icon: Icon(Icons.lock),
                    ), ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return ForgotPasswordPage();
                          }, ) );
                        },
                        child: Text('Forget password?',
                          style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,),
                        ),
                      ),
                    ],
                  ),
                ),
          
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: singIn,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(
                        child: Text(
                          'Sign In', style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
                      ),
                    ),
                  ),
                ),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?'),
          
                    SizedBox(width: 10,),
          
                    GestureDetector(
                      onTap: widget.showRegisterPage,
                      child: Text('Register now', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),),
                    )
                  ],
                ),
          
          
            ],),
          ),
        ),
      )
    );
  }
}
