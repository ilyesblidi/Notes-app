import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/pages/notification_page.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
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
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void openNoteBox({String? docID, String? oldTitle, String? oldContent}) {
    _titleController.text = oldTitle ?? '';
    _contentController.text = oldContent ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(docID == null ? 'Add Note' : 'Update Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Content'),
                controller: _contentController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (docID == null) {
                  _firestoreService.addNote(
                    _titleController.text,
                    _contentController.text,
                  );
                } else {
                  _firestoreService.updateNote(
                    docID,
                    _titleController.text,
                    _contentController.text,
                  );
                }

                _titleController.clear();
                _contentController.clear();
                Navigator.of(context).pop();
              },
              child: Text(docID == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openNoteBox();
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
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
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
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
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
                              navigatorKey.currentState?.pushNamed('/notification_page');
                            },
                            child: const Icon(
                              Icons.notifications_active_rounded,
                              color: Colors.deepPurple,
                              size: 30,
                            ),
                          ),
                          if (globalNotifications.isNotEmpty)
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
                      )
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

                    final notes =
                        snapshot.data!
                            .where(
                              (note) =>
                                  note['title']?.toLowerCase().contains(
                                    _searchQuery.toLowerCase(),
                                  ) ??
                                  false ||
                                      note['content']?.toLowerCase().contains(
                                        _searchQuery.toLowerCase(),
                                      ) ??
                                  false,
                            )
                            .toList();

                    return GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Two columns
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 3 / 4, // Adjust card height
                          ),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        final timestamp =
                            note['timestamp'] != null
                                ? (note['timestamp'] as Timestamp)
                                : null;
                        final formattedDate =
                            timestamp != null
                                ? DateFormat(
                                  'MMMM d, h:mm a',
                                ).format(timestamp.toDate())
                                : 'No Date';

                        return Card(
                          color: Color(0xCCFFFFFF),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    note['title'] ?? 'No Title',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  note['content'] ?? 'No Content',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          openNoteBox(
                                            docID: note['id'],
                                            oldTitle: note['title'],
                                            oldContent: note['content'],
                                          );
                                        },
                                      ),
                                    ),
                                    Flexible(
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          _firestoreService.deleteNote(
                                            note['id'],
                                          );
                                        },
                                      ),
                                    ),
                                    Flexible(
                                      child: IconButton(
                                        icon: Icon(
                                          globalFavoriteNotes.any(
                                                (favNote) =>
                                                    favNote['id'] == note['id'],
                                              )
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color:
                                              globalFavoriteNotes.any(
                                                    (favNote) =>
                                                        favNote['id'] ==
                                                        note['id'],
                                                  )
                                                  ? Colors.red
                                                  : Colors.grey,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (globalFavoriteNotes.any(
                                              (favNote) =>
                                                  favNote['id'] == note['id'],
                                            )) {
                                              globalFavoriteNotes.removeWhere(
                                                (favNote) =>
                                                    favNote['id'] == note['id'],
                                              );
                                            } else {
                                              globalFavoriteNotes.add(
                                                note.map(
                                                  (key, value) => MapEntry(
                                                    key,
                                                    value.toString(),
                                                  ),
                                                ),
                                              );
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
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
