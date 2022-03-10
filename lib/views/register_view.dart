import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

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
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
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
              devtools.log('Button pressed');
              final email = _email.text;
              try {
                final password = _password.text;
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                devtools.log('User credential: $userCredential');
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'invalid-email':
                    devtools.log('Invalid email');
                    break;
                  case 'email-already-in-use':
                    devtools.log('Email already in use');
                    break;
                  case 'weak-password':
                    devtools.log('Weak Password');
                    break;
                  default:
                    devtools.log('Something bad happened');
                    devtools.log(e.code);
                }
              }
            },
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
                '/login',
                (_) => false,
              );
            },
            child: const Text('Login here!'),
          ),
        ],
      ),
    );
  }
}
