import 'package:flutter/material.dart';
import 'package:zapys/constants/routes.dart';
import 'package:zapys/services/auth/auth_exceptions.dart';
import 'package:zapys/services/auth/auth_service.dart';
import 'package:zapys/util/show_error_dialog.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
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
          onPressed: _logInAndCatchException,
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
            Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute,
              (_) => false,
            );
          },
          child: const Text('Login here!'),
        ),
      ],
    );
  }

  void _logInAndCatchException() async {
    final email = _email.text;
    final password = _password.text;

    try {
      await AuthService.firebase().createUser(
        email: email,
        password: password,
      );
      await AuthService.firebase().sendEmailVerificationOut();
      Navigator.of(context).pushNamed(verifyEmailRoute);
    } on InvalidEmailAuthException {
      await showErrorDialog(context, 'Invalid email!');
    } on EmailAlreadyInUseAuthException {
      await showErrorDialog(context, 'Email already in use!');
    } on WeakPasswordAuthException {
      await showErrorDialog(context, 'Weak Password!');
    } on GenericAuthException {
      await showErrorDialog(
          context, 'Something bad happened! Authentication exception!');
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
