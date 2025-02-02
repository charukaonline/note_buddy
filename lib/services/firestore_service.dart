import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a note for the logged-in user
  Future<void> addNote(String title, String content) async {
    try {
      String userId = _auth.currentUser!.uid;
      await _firestore.collection("notes").add({
        "userId": userId,
        "title": title,
        "content": content,
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding note: $e");
    }
  }

  // Get notes for the current user
  Stream<QuerySnapshot> getUserNotes() {
    String userId = _auth.currentUser!.uid;
    return _firestore
        .collection("notes")
        .where("userId", isEqualTo: userId)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    try {
      await _firestore.collection("notes").doc(noteId).delete();
    } catch (e) {
      print("Error deleting note: $e");
    }
  }
}
