import 'package:flutter/material.dart';
import 'package:zapys/constants/strings.dart';
import 'package:zapys/util/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context, String noteTitle) {
  return showGenericDialog(
    context: context,
    title: deleteNoteDialogTitle + noteTitle,
    content: deleteNoteDialogContent + noteTitle + '?',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete': true,
    },
  ).then((value) => value ?? false);
}
