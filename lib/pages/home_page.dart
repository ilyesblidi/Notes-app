import 'package:cloud_firestore/cloud_firestore.dart';
                                                            import 'package:flutter/material.dart';
                                                            import 'package:intl/intl.dart';
                                                            import 'package:notes_app/services/firestore.dart';
                                                            import 'package:notes_app/utils/global_favorites.dart';

                                                            class HomePage extends StatefulWidget {
                                                              const HomePage({super.key});

                                                              @override
                                                              State<HomePage> createState() => _HomePageState();
                                                            }

                                                            class _HomePageState extends State<HomePage> {
                                                              final FirestoreService _firestoreService = FirestoreService();
                                                              final TextEditingController _searchController = TextEditingController();
                                                              String _searchQuery = '';

                                                              @override
                                                              void initState() {
                                                                super.initState();
                                                                _searchController.addListener(() {
                                                                  setState(() {
                                                                    _searchQuery = _searchController.text;
                                                                  });
                                                                });
                                                              }

                                                              @override
                                                              void dispose() {
                                                                _searchController.dispose();
                                                                super.dispose();
                                                              }

                                                              @override
                                                              Widget build(BuildContext context) {
                                                                return SafeArea(
                                                                  child: Scaffold(
                                                                    floatingActionButton: FloatingActionButton(
                                                                      onPressed: () {
                                                                        // Add your note creation logic here
                                                                      },
                                                                      child: const Icon(Icons.add),
                                                                    ),
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
                                                                          // Header Section
                                                                          Padding(
                                                                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.deepPurple.withOpacity(0.1),
                                                                                borderRadius: BorderRadius.circular(12),
                                                                              ),
                                                                              padding: const EdgeInsets.all(12),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(30),
                                                                                        child: Image.asset(
                                                                                          'lib/assets/profil.jpg',
                                                                                          fit: BoxFit.cover,
                                                                                          height: 60,
                                                                                          width: 60,
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(width: 16),
                                                                                      Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: const [
                                                                                          Text(
                                                                                            'Good Morning!',
                                                                                            style: TextStyle(fontSize: 16, color: Colors.grey),
                                                                                          ),
                                                                                          Text(
                                                                                            'Lyes',
                                                                                            style: TextStyle(
                                                                                              fontSize: 22,
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Stack(
                                                                                    children: [
                                                                                      GestureDetector(
                                                                                        onTap: () {
                                                                                          // Navigate to Notification Page
                                                                                        },
                                                                                        child: const Icon(
                                                                                          Icons.notifications_active_rounded,
                                                                                          color: Colors.deepPurple,
                                                                                          size: 30,
                                                                                        ),
                                                                                      ),
                                                                                      Positioned(
                                                                                        right: 0,
                                                                                        top: 0,
                                                                                        child: Container(
                                                                                          height: 10,
                                                                                          width: 10,
                                                                                          decoration: const BoxDecoration(
                                                                                            color: Colors.red,
                                                                                            shape: BoxShape.circle,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          // Search Bar
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(16.0),
                                                                            child: TextField(
                                                                              controller: _searchController,
                                                                              decoration: InputDecoration(
                                                                                hintText: "Search notes...",
                                                                                prefixIcon: const Icon(Icons.search, color: Colors.white),
                                                                                filled: true,
                                                                                fillColor: Colors.white.withOpacity(0.2),
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                  borderSide: BorderSide.none,
                                                                                ),
                                                                                hintStyle: const TextStyle(color: Colors.white70),
                                                                              ),
                                                                              style: const TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                          // Notes List
                                                                          Expanded(
                                                                            child: StreamBuilder<List<Map<String, dynamic>>>(
                                                                              stream: _firestoreService.getNotes(),
                                                                              builder: (context, snapshot) {
                                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                                  return const Center(child: CircularProgressIndicator());
                                                                                }
                                                                                if (snapshot.hasError) {
                                                                                  return const Center(child: Text('Error loading notes'));
                                                                                }
                                                                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                                                                  return const Center(
                                                                                    child: Text(
                                                                                      'No notes available',
                                                                                      style: TextStyle(color: Colors.white70, fontSize: 18),
                                                                                    ),
                                                                                  );
                                                                                }

                                                                                final notes = snapshot.data!
                                                                                    .where((note) =>
                                                                                        note['title']?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false ||
                                                                                        note['content']?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
                                                                                    .toList();

                                                                                return ListView.builder(
                                                                                  padding: const EdgeInsets.all(16.0),
                                                                                  itemCount: notes.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    final note = notes[index];
                                                                                    final timestamp = note['timestamp'] != null
                                                                                        ? (note['timestamp'] as Timestamp)
                                                                                        : null;
                                                                                    final formattedDate = timestamp != null
                                                                                        ? DateFormat('MMMM d, h:mm a').format(timestamp.toDate())
                                                                                        : 'No Date';

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
                                                                                        subtitle: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            const SizedBox(height: 8),
                                                                                            Text(
                                                                                              note['content'] ?? 'No Content',
                                                                                              style: const TextStyle(
                                                                                                fontSize: 14,
                                                                                                color: Colors.black54,
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(height: 8),
                                                                                            Text(
                                                                                              formattedDate,
                                                                                              style: const TextStyle(
                                                                                                fontSize: 12,
                                                                                                color: Colors.grey,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        trailing: Row(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                            IconButton(
                                                                                              icon: const Icon(Icons.edit, color: Colors.blue),
                                                                                              onPressed: () {
                                                                                                // Add edit logic here
                                                                                              },
                                                                                            ),
                                                                                            IconButton(
                                                                                              icon: const Icon(Icons.delete, color: Colors.red),
                                                                                              onPressed: () {
                                                                                                // Add delete logic here
                                                                                              },
                                                                                            ),
                                                                                            IconButton(
                                                                                              icon: Icon(
                                                                                                globalFavoriteNotes.any((favNote) => favNote['id'] == note['id'])
                                                                                                    ? Icons.favorite
                                                                                                    : Icons.favorite_border,
                                                                                                color: globalFavoriteNotes.any((favNote) => favNote['id'] == note['id'])
                                                                                                    ? Colors.red
                                                                                                    : Colors.grey,
                                                                                              ),
                                                                                              onPressed: () {
                                                                                                setState(() {
                                                                                                  if (globalFavoriteNotes.any((favNote) => favNote['id'] == note['id'])) {
                                                                                                    globalFavoriteNotes.removeWhere((favNote) => favNote['id'] == note['id']);
                                                                                                  } else {
                                                                                                    globalFavoriteNotes.add(note.map((key, value) => MapEntry(key, value.toString())));
                                                                                                  }
                                                                                                });
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            }