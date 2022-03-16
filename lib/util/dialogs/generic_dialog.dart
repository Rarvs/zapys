import 'package:flutter/material.dart';

typedef DialogOptionBuild<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuild optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: options.keys.map((optionTitle) {
            final value = options[optionTitle];
            return TextButton(
              onPressed: () {
                value == null
                    ? Navigator.of(context).pop()
                    : Navigator.of(context).pop(value);
              },
              child: Text(optionTitle),
            );
          }).toList(),
        );
      });
}
