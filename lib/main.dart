import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zapys/constants/routes.dart';
import 'package:zapys/services/auth/bloc/auth_bloc.dart';
import 'package:zapys/services/auth/firebase_auth_provider.dart';
import 'package:zapys/util/theme/custom_theme.dart';
import 'package:zapys/views/home_page.dart';
import 'package:zapys/views/login_view.dart';
import 'package:zapys/views/notes/create_update_note_view.dart';
import 'package:zapys/views/notes/notes_view.dart';
import 'package:zapys/views/register_view.dart';
import 'package:zapys/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.defaultTheme,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}
