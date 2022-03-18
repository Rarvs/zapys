import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zapys/services/cloud_firestore/cloud_note.dart';
import 'package:zapys/util/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
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
        final note = notes.elementAt(index);
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
          leading: IconButton(
            onPressed: () {
              Share.share(note.text);
            },
            icon: const Icon(Icons.share),
          ),
        );
      },
    );
  }
}
