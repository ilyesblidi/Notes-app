import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Initialize any necessary data or state here
    // For example, you can set up a listener for the search controller
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

  void openNoteBox({String? docID, String? oldTitle, String? oldContent}) {
  // Pre-fill the controllers with old data if available
  if (docID != null) {
    _titleController.text = oldTitle ?? '';
    _contentController.text = oldContent ?? '';
  } else {
    _titleController.clear();
    _contentController.clear();
  }

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

        backgroundColor: Colors.white,

        bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          height: 60,
          backgroundColor: Colors.white,
          color: Colors.orange,
          items: <Widget>[
            Icon(Icons.home),
            Icon(Icons.favorite),
            Icon(Icons.settings),
          ],
          onTap: (index) {
            //Handle button tap
          },
        ),

        // appBar: AppBar(
        //     title: const Text('Notes App', style:
        //       TextStyle(
        //         color: Colors.white,
        //       )
        //       ,),
        //     backgroundColor: Colors.deepPurple[700],
        // ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your action here
            openNoteBox();
          },
          child: const Icon(Icons.add),
        ),

        body: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        'lib/assets/profil.jpg', // Add your illustration here
                        fit: BoxFit.contain,
                        height: 60,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Good Morning!', style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),),
                          Text('Lyes', style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.notifications_active_rounded , color: Colors.deepPurple,),
                )

              ],),
            ),

            /// Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search your notes",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            /// Displaying notes
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
                    return const Center(child: Text('No notes available'));
                  }

                  final notes = snapshot.data!
                      .where((note) =>
                  note['title']
                      ?.toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ??
                      false ||
                          note['content']
                              ?.toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ??
                      false)
                      .toList();

                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final timestamp = note['timestamp'] != null
                          ? (note['timestamp'] as Timestamp)
                          : null;
                      final formattedDate = timestamp != null
                          ? DateFormat('MMMM d, h:mm a')
                          .format(timestamp.toDate())
                          : 'No Date';

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    openNoteBox(
                                      docID: note['id'],
                                      oldTitle: note['title'],
                                      oldContent: note['content'],
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _firestoreService.deleteNote(note['id']);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                            title: Text(
                              note['title'] ?? 'No Title',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(note['content'] ?? 'No Content'),
                                const SizedBox(height: 8),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    color: Colors.brown,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}
