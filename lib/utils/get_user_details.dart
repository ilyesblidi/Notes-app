import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserDetails extends StatelessWidget {

  final String documentId;

  const GetUserDetails({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder(
        future: users.doc(documentId).get() ,
        builder:  (context, snapshot) {
          if ( snapshot.connectionState == ConnectionState.done ) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              return Text('${data['first name']} ${data['last name']}');
            } else {
              return const Text('L O A D I N G');
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
    ) ;
  }
}
