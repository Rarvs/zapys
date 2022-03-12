import 'package:flutter/material.dart';
import 'package:zapys/constants/routes.dart';
import 'package:zapys/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text(
              "A verification email has been sent to you, please check your spam box if you haven't found it. Or click the button bellow to resend the email"),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Resend email verificatiion'),
          ),
          TextButton(
            onPressed: () async {
              AuthService.firebase().logOut;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (_) => false);
            },
            child: const Text("Get me out of here!"),
          )
        ],
      ),
    );
  }
}
