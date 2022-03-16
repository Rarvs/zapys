import 'package:flutter/material.dart';

import 'package:zapys/constants/routes.dart';
import 'package:zapys/services/auth/auth_exceptions.dart';
import 'package:zapys/services/auth/auth_service.dart';
import 'package:zapys/util/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: 'Enter email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );

                final user = AuthService.firebase().currentUser;
                user?.isEmailVerified ?? false
                    ? Navigator.of(context).restorablePushNamedAndRemoveUntil(
                        notesRoute,
                        (_) => false,
                      )
                    : Navigator.of(context).restorablePushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (_) => false,
                      );
              } on UserNotFoundAuthException {
                await showErrorDialog(context, 'User not found!');
              } on WrongPasswordAuthException {
                await showErrorDialog(context, 'Wrong credentials!');
              } on GenericAuthException {
                await showErrorDialog(context,
                    'Something bad happened! Authentication exception');
              }
            },
            child: const Text('Login'),
          ),
          const SizedBox(
            height: 32,
          ),
          const Text(
            'Not registered yet? ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (_) => false,
              );
            },
            child: const Text('Register here!'),
          ),
        ],
      ),
    );
  }
}
