import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zapys/constants/strings.dart';
import 'package:zapys/services/auth/auth_exceptions.dart';
import 'package:zapys/services/auth/bloc/auth_bloc.dart';
import 'package:zapys/services/auth/bloc/auth_event.dart';
import 'package:zapys/services/auth/bloc/auth_state.dart';
import 'package:zapys/util/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, weakPasswordTxt);
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, invalidEmailTxt);
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, emailAlreadyInUseTxt);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, genericAuthErrorTxt);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            autofocus: true,
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
            onPressed: _register,
            child: const Text('Register'),
          ),
          const SizedBox(
            height: 32,
          ),
          const Text(
            'Already have a login? ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventLogOut());
            },
            child: const Text('Login here!'),
          ),
        ],
      ),
    );
  }

  void _register() async {
    final email = _email.text;
    final password = _password.text;

    context.read<AuthBloc>().add(AuthEventRegister(email, password));
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
