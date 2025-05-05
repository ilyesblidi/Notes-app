import 'package:flutter/material.dart';
                import 'package:notes_app/utils/global_favorites.dart';

                class FavoritesPage extends StatelessWidget {
                  const FavoritesPage({super.key});

                  @override
                  Widget build(BuildContext context) {
                    return Scaffold(
                      body: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.deepPurple, Colors.purpleAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 50),
                            // Title
                            const Center(
                              child: Text(
                                'Favorites',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Favorites List or Empty State
                            Expanded(
                              child: globalFavoriteNotes.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No favorite notes yet!',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.all(16.0),
                                      itemCount: globalFavoriteNotes.length,
                                      itemBuilder: (context, index) {
                                        final note = globalFavoriteNotes[index];
                                        return Card(
                                          margin: const EdgeInsets.only(bottom: 16.0),
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: ListTile(
                                            contentPadding: const EdgeInsets.all(16.0),
                                            leading: const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                              size: 30,
                                            ),
                                            title: Text(
                                              note['title'] ?? 'No Title',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            subtitle: Text(
                                              note['content'] ?? 'No Content',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
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
                          ],
                        ),
                      ),
                    );
                  }
                }