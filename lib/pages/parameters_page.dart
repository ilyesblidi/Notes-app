import 'package:flutter/material.dart';

class ParametersPage extends StatelessWidget {
  const ParametersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parameters'),
        backgroundColor: const Color(0xFF2F1859), // Dark purple color
      ),
      body: const Center(
        child: Text(
          'No parameters available yet!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2F1859), // Dark purple color
      ),
    );
  }
}
