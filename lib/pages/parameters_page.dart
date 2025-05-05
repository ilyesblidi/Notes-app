import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/main.dart';

import 'change_password_page.dart';

                    class ParametersPage extends StatelessWidget {
                      const ParametersPage({super.key});

                      @override
                      Widget build(BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(
                            title: const Text(
                              'Settings',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            flexibleSpace: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.deepPurple, Colors.purpleAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          body: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.deepPurple, Colors.purpleAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ListView(
                              padding: const EdgeInsets.all(16.0),
                              children: [
                                const Text(
                                  'General Settings',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ListTile(
                                  leading: const Icon(Icons.dark_mode, color: Colors.orange),
                                  title: const Text('Dark Mode', style: TextStyle(color: Colors.white)),
                                  trailing: Switch(
                                    value: false,
                                    onChanged: (value) {
                                      // Handle dark mode toggle
                                    },
                                  ),
                                ),
                                const Divider(color: Colors.white54),
                                ListTile(
                                  leading: const Icon(Icons.notifications, color: Colors.orange),
                                  title: const Text('Notifications', style: TextStyle(color: Colors.white)),
                                  trailing: Switch(
                                    value: true,
                                    onChanged: (value) {
                                      // Handle notifications toggle
                                    },
                                  ),
                                ),
                                const Divider(color: Colors.white54),
                                const SizedBox(height: 30),
                                const Text(
                                  'Account Settings',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ListTile(
                                  leading: const Icon(Icons.person, color: Colors.orange),
                                  title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                                  onTap: () {
                                    // Navigate to edit profile page
                                  },
                                ),
                                const Divider(color: Colors.white54),
                                ListTile(
                                  leading: const Icon(Icons.lock, color: Colors.orange),
                                  title: const Text('Change Password', style: TextStyle(color: Colors.white)),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                                    );
                                  },
                                ),
                                const Divider(color: Colors.white54),
                                const SizedBox(height: 30),
                                const Text(
                                  'Other',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ListTile(
                                  leading: const Icon(Icons.info, color: Colors.orange),
                                  title: const Text('About App', style: TextStyle(color: Colors.white)),
                                  onTap: () {
                                    // Show about app dialog
                                    showAboutDialog(
                                      context: context,
                                      applicationName: 'Notes App',
                                      applicationVersion: '1.0.0',
                                      applicationIcon: const Icon(Icons.note, size: 40, color: Colors.orange),
                                      children: [
                                        const Text('This is a simple notes app to manage your daily tasks.'),
                                        const SizedBox(height: 12),
                                        const Text('Developped by : Lyes Blidi', textAlign: TextAlign.center,style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),),
                                      ],
                                    );
                                  },
                                ),
                                const Divider(color: Colors.white54),
                                GestureDetector(
                                  onTap: () async {
                                    try {
                                      await FirebaseAuth.instance.signOut();
                                      // Optionally navigate to the login page after logout
                                      navigatorKey.currentState?.pushNamed('/login_page');
                                    } catch (e) {
                                      // Log the error or show a message to the user
                                      print('Error during logout: $e');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Failed to log out. Please try again.')),
                                      );
                                    }
                                  },
                                  child: ListTile(
                                    leading: const Icon(Icons.logout, color: Colors.red),
                                    title: const Text('Logout', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }