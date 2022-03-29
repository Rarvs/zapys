import 'package:flutter/material.dart';
import 'package:zapys/constants/strings.dart';
import 'package:zapys/util/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: errorDialogTitleTxt,
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
