import 'package:flutter/material.dart';
import 'package:zapys/constants/routes.dart';
import 'package:zapys/views/home_page.dart';
import 'package:zapys/views/login_view.dart';
import 'package:zapys/views/notes/new_notes_view.dart';
import 'package:zapys/views/notes/notes_view.dart';
import 'package:zapys/views/register_view.dart';
import 'package:zapys/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        newNoteRoute: (context) => const NewNoteView(),
      },
    ),
  );
}
