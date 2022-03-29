import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zapys/constants/routes.dart';
import 'package:zapys/constants/strings.dart';
import 'package:zapys/services/auth/auth_exceptions.dart';
import 'package:zapys/services/auth/bloc/auth_bloc.dart';
import 'package:zapys/services/auth/bloc/auth_event.dart';
import 'package:zapys/services/auth/bloc/auth_state.dart';
import 'package:zapys/util/dialogs/error_dialog.dart';
import 'package:zapys/util/dialogs/loading_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;

          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialogHandle =
                showLoadingDialog(context: context, text: loadingTxt);
          }

          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found!');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials!');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
                context, 'Something bad happened! Authentication exception');
          }
        }
      },
      child: Scaffold(
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
                context.read<AuthBloc>().add(
                      AuthEventLogIn(
                        email,
                        password,
                      ),
                    );
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
                context.read<AuthBloc>().add(const AuthEventShouldRegister());
              },
              child: const Text('Register here!'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> authStateExceptionHandling(
      AuthState state, BuildContext context) async {}
}
