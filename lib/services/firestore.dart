import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of notes

  final CollectionReference notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  // Create : add a new note

  Future<void> addNote(String title, String content, {String? imageId}) async {
    try {
      await notes.add({
        'title': title,
        'content': content,
        'imageId': imageId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  // READ : get all notes from data base

  Stream<List<Map<String, dynamic>>> getNotes() {
    return notes
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Add the document ID
      return data;
    }).toList());
  }

  // UBDATE : update a note

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

  // DELETE : delete a note

  Future<void> deleteNote(String id) async {
    try {
      await notes.doc(id).delete();
    } catch (e) {
      print('Error deleting note: $e');
    }
  }
}
