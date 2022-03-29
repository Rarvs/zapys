import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zapys/constants/routes.dart';
import 'package:zapys/services/auth/auth_exceptions.dart';
import 'package:zapys/services/auth/bloc/auth_bloc.dart';
import 'package:zapys/services/auth/bloc/auth_event.dart';
import 'package:zapys/services/auth/bloc/auth_state.dart';
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
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              await authStateExceptionHandling(state, context);
            },
            child: TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(
                      AuthEventLogIn(
                        email,
                        password,
                      ),
                    );
              },
              child: const Text('Login'),
            ),
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

  Future<void> authStateExceptionHandling(
      AuthState state, BuildContext context) async {
    if (state is AuthStateLoggedOut) {
      if (state.exception is UserNotFoundAuthException) {
        await showErrorDialog(context, 'User not found!');
      } else if (state.exception is WrongPasswordAuthException) {
        await showErrorDialog(context, 'Wrong credentials!');
      } else if (state.exception is GenericAuthException) {
        await showErrorDialog(
            context, 'Something bad happened! Authentication exception');
      }
    }
  }
}
