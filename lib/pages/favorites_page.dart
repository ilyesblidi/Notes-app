import 'package:flutter/material.dart';
                              import 'package:notes_app/utils/global_favorites.dart';

                              class FavoritesPage extends StatelessWidget {
                                const FavoritesPage({super.key});

                                @override
                                Widget build(BuildContext context) {
                                  return Scaffold(
                                    appBar: AppBar(
                                      title: const Text(
                                        'Favorite Notes',
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
                                      child: globalFavoriteNotes.isEmpty
                                          ? const Center(
                                              child: Text(
                                                'No favorite notes yet!',
                                                style: TextStyle(fontSize: 18, color: Colors.white70),
                                              ),
                                            )
                                          : ListView.builder(
                                              padding: const EdgeInsets.all(16.0),
                                              itemCount: globalFavoriteNotes.length,
                                              itemBuilder: (context, index) {
                                                final note = globalFavoriteNotes[index];
                                                return Card(
                                                  margin: const EdgeInsets.only(bottom: 16.0),
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: ListTile(
                                                    contentPadding: const EdgeInsets.all(16.0),
                                                    title: Text(
                                                      note['title'] ?? 'No Title',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      note['content'] ?? 'No Content',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    trailing: IconButton(
                                                      icon: const Icon(Icons.delete, color: Colors.red),
                                                      onPressed: () {
                                                        globalFavoriteNotes.removeAt(index);
                                                        (context as Element).markNeedsBuild();
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                  );
                                }
                              }