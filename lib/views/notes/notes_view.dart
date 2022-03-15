import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:zapys/constants/routes.dart';
import 'package:zapys/enums/menu_action.dart';
import 'package:zapys/services/auth/auth_service.dart';
import 'package:zapys/services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.closeDataBase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(newNoteRoute);
        },
      ),
      appBar: AppBar(
        title: const Text('Your notes'),
        actions: [
          PopupMenuButton(
            offset: Offset.fromDirection(1),
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await _showLogOutDialog(context);
                  shouldLogout ? _logOut() : null;
                  break;
                default:
              }
              _showLogOutDialog(context);
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return const Text('Waiting for all notes...');
                      default:
                        return const CircularProgressIndicator();
                    }
                  });
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<bool> _showLogOutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  void _logOut() async {
    await AuthService.firebase().logOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
      loginRoute,
      (_) => false,
    );
  }
}