import 'package:flutter/material.dart';
import 'package:zapys/constants/strings.dart';
import 'package:zapys/util/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: resetPasswordEmailSentDialogTitleTxt,
      content: resetPasswordEmailSentDialogContetTxt,
      optionsBuilder: () => {
            'Ok': null,
          });
}
