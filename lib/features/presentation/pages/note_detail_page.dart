// lib/presentation/pages/note_detail_page.dart
import 'package:flutter/material.dart';
import '../../domain/entities/note.dart';

import '../widgets/note_form.dart';

class NoteDetailPage extends StatelessWidget {
  final Transaction? note;

  const NoteDetailPage({Key? key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? "Eslatma qo'shish" : "Eslatmani yangilash"),
        elevation: 0,
      ),
      body: NoteForm(note: note),
    );
  }
}
