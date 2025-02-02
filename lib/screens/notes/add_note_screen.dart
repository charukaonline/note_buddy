import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../home/home_screen.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  void _saveNote() async {
    String title = titleController.text.trim();
    String content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and Content cannot be empty")),
      );
      return;
    }

    await _firestoreService.addNote(title, content);
    Navigator.pop(context); // Go back to the Home Screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Note")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: InputDecoration(labelText: "Content"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text("Save Note"),
            ),
          ],
        ),
      ),
    );
  }
}
