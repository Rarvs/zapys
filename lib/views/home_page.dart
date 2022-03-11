import 'package:flutter/material.dart';
import 'package:zapys/services/auth/auth_service.dart';
import 'package:zapys/views/login_view.dart';
import 'package:zapys/views/notes_view.dart';
import 'package:zapys/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              final isUserEmailVerified = user.isEmailVerified;
              if (isUserEmailVerified) {
                devtools.log('User verified');
                return const NotesView();
              } else {
                devtools.log('User need to verify email');
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
