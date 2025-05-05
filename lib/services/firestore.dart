import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';

  class FirestoreService {
    final CollectionReference notes = FirebaseFirestore.instance.collection('notes');
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Create: Add a new note
    Future<void> addNote(String title, String content, {String? imageId}) async {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          await notes.add({
            'title': title,
            'content': content,
            'imageId': imageId,
            'uid': user.uid, // Associate note with user
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      } catch (e) {
        print('Error adding note: $e');
      }
    }

    // Read: Get all notes for the current user
    Stream<List<Map<String, dynamic>>> getNotes() {
      final user = _auth.currentUser;
      if (user != null) {
        return notes
            .where('uid', isEqualTo: user.uid) // Filter by user UID
            .snapshots()
            .map((snapshot) => snapshot.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  data['id'] = doc.id; // Add the document ID
                  return data;
                }).toList());
      }
      return const Stream.empty();
    }

    // Update: Update a note
    Future<void> updateNote(String id, String title, String content, {String? imageId}) async {
      try {
        await notes.doc(id).update({
          'title': title,
          'content': content,
          'imageId': imageId,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Error updating note: $e');
      }
    }

    // Delete: Delete a note
    Future<void> deleteNote(String id) async {
      try {
        await notes.doc(id).delete();
      } catch (e) {
        print('Error deleting note: $e');
      }
    }
  }