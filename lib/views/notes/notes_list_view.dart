import 'package:flutter/material.dart';
import 'package:zapys/services/crud/database_note.dart';
import 'package:zapys/util/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        final noteTitle = 'Nota ${index + 1}';
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(noteTitle),
          subtitle: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context, noteTitle);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        );
      },
    );
  }
}
