import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Notes App')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
          openNoteBox();
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
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

      final notes = snapshot.data!;
      return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () {
                  // ubdating the note
                  openNoteBox(docID: note['id'],
                    oldTitle: note['title'],
                    oldContent: note['content'],);
                } ,
                icon: Icon(Icons.settings)),

                IconButton(
                  onPressed: () {
                    // deleting the note
                    _firestoreService.deleteNote(note['id']);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            title: Text(note['title'] ?? 'No Title'),
            subtitle: Text(note['content'] ?? 'No Content'),
          );
        },
      );
    },
    ),

    );
  }
}
