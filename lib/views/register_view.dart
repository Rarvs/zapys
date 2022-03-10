import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              debugPrint('Button pressed');
              final email = _email.text;
              try {
                final password = _password.text;
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                debugPrint('User credential: $userCredential');
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'invalid-email':
                    debugPrint('Invalid email');
                    break;
                  case 'email-already-in-use':
                    debugPrint('Email already in use');
                    break;
                  case 'weak-password':
                    debugPrint('Weak Password');
                    break;
                  default:
                    debugPrint('Something bad happened');
                    debugPrint(e.code);
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
                (route) => false,
              );
            },
            child: const Text('Login here!'),
          ),
        ],
      ),
    );
  }
}
