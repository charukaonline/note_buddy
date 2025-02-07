import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditNoteScreen extends StatefulWidget {
  final String noteId;
  final String initialTitle;
  final String initialContent;

  const EditNoteScreen({
    Key? key,
    required this.noteId,
    required this.initialTitle,
    required this.initialContent,
  }) : super(key: key);

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController titleController;
  late TextEditingController contentController;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> _updateNote() async {
    if (titleController.text.trim().isEmpty ||
        contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and content cannot be empty")),
      );
      return;
    }

    setState(() {
      isUpdating = true;
    });

    try {
      await _firestore.collection("notes").doc(widget.noteId).update({
        "title": titleController.text.trim(),
        "content": contentController.text.trim(),
        "timestamp": FieldValue.serverTimestamp(), // Update timestamp
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Note updated successfully!")),
      );

      Navigator.pop(context); // Return to previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update note: $e")),
      );
    } finally {
      setState(() {
        isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: isUpdating ? null : _updateNote,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: "Content",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isUpdating ? null : _updateNote,
              child: isUpdating
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Update Note"),
            ),
          ],
        ),
      ),
    );
  }
}
