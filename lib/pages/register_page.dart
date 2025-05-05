import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {

  final VoidCallback showLoginPage ;

  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();
  final confirmpassword = _confirmpasswordController.text.trim();

  if (email.isEmpty || password.isEmpty || confirmpassword.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill all the fields'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a valid email address'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (password.length < 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password must be at least 6 characters long'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (password != confirmpassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passwords do not match'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await addUserDetails(
      _firstnameController.text.trim(),
      _lastnameController.text.trim(),
      _phoneController.text.trim(),
      _emailController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sign up successful'),
        backgroundColor: Colors.green,
      ),
    );
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message ?? 'An error occurred'),
        backgroundColor: Colors.red,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An unexpected error occurred'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  Future addUserDetails( String firstname, String lastname, String phone, String email ) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'first name': firstname,
        'last name': lastname,
        'phone number': phone,
        'email': email,
      });
      print('User details added successfully');
    } catch (e) {
      print('Failed to add user details: $e');
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

                  //Icon(Icons.android , size: 80,),

                  Text('Hello there!', style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),),

                  SizedBox(height: 10,),

                  Text('Register bellow with your details', style: TextStyle(
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
                        controller: _firstnameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'First Name',
                          //icon: Icon(Icons.person),
                        ), ),
                    ),
                  ),

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
                        controller: _lastnameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Last Name',
                          //icon: Icon(Icons.person),
                        ), ),
                    ),
                  ),

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
                        controller: _phoneController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone Number',
                          //icon: Icon(Icons.person),
                        ), ),
                    ),
                  ),

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
                    padding: const EdgeInsets.all(15.0),
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
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10 ,vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.deepPurple, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: TextField(
                        controller: _confirmpasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Confirm Password',
                          icon: Icon(Icons.lock),
                        ), ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: signUp,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(
                          child: Text(
                            'Sign Up', style: TextStyle(
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
                      Text('I am a member'),

                      SizedBox(width: 10,),

                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: Text('Login', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
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
