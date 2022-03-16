import 'package:flutter/cupertino.dart';
import 'package:zapys/constants/strings.dart';
import 'package:zapys/util/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: errorDialogTitle,
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
