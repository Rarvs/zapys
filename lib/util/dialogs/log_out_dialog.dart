import 'package:flutter/material.dart';
import 'package:zapys/constants/strings.dart';
import 'package:zapys/util/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: logOutDialogTitleTxt,
    content: logOutDialogContentTxt,
    optionsBuilder: () => {
      'Cancel': false,
      'Log Out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
