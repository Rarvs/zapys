import 'package:flutter/material.dart';
import 'package:zapys/constants/strings.dart';
import 'package:zapys/util/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: cannotShareNoteDialogTitleTxt,
    content: cannotShareNoteDialogContentTxt,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
