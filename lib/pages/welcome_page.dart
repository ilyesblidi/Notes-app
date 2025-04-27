import 'package:flutter/material.dart';

import 'home_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F1859), // Dark purple background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Illustration
            Expanded(
              flex: 5,
              child: Center(
                child: Image.asset(
                  'lib/assets/note.png', // Add your illustration here
                  fit: BoxFit.contain,
                  height: 300,
                ),
              ),
            ),

            // Title and Subtitle
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "The Next Dimension\nof Notebooks",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Get your everyday thoughts, manage your works in one place.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton.icon(
                icon: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 12, top: 7, bottom: 7),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    width: 50,
                    height: 50,
                    child: const Icon(
                      size: 30,
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54, // Orange color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomePage()),
                  );
                },
                label: const Text(
                  "Start Now",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}