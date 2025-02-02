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
}
