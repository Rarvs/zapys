import 'package:firebase_core/firebase_core.dart';
import 'package:zapys/firebase_options.dart';
import 'package:zapys/services/auth/auth_user.dart';
import 'package:zapys/services/auth/auth_provider.dart';
import 'package:zapys/services/auth/auth_exceptions.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (firabaseException) {
      switch (firabaseException.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'email-already-in-use':
          throw EmailAlreadyInUseAuthException();
        case 'weak-password':
          throw WeakPasswordAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (genericException) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (firebaseException) {
      switch (firebaseException.code) {
        case 'user-not-found':
          throw UserNotFoundAuthException();
        case 'wrong-password':
          throw WrongPasswordAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (genericException) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    user != null
        ? await FirebaseAuth.instance.signOut()
        : throw UserNotLoggedInAuthException();
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    user != null
        ? await user.sendEmailVerification()
        : throw UserNotLoggedInAuthException();
  }
}
