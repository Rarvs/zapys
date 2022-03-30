import 'package:bloc/bloc.dart';
import 'package:zapys/services/auth/auth_provider.dart';
import 'package:zapys/services/auth/bloc/auth_event.dart';
import 'package:zapys/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUnitialized(isLoading: true)) {
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ));
    });
    on<AuthEventSendEmailVerifictaion>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (exception) {
        emit(AuthStateRegistering(
          exception: exception,
          isLoading: false,
        ));
      }
    });
    on<AuthEventInitialize>(
      ((event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } else if (user.isEmailVerified == false) {
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      }),
    );
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
          exception: null, isLoading: true, loadingText: 'Loggin in...'));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (user.isEmailVerified == false) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (exception) {
        emit(AuthStateLoggedOut(exception: exception, isLoading: false));
      }
    });
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } on Exception catch (exception) {
          emit(AuthStateLoggedOut(exception: exception, isLoading: false));
        }
      },
    );
    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ));
        final email = event.email;
        if (email == null) {
          return;
        } else {
          emit(const AuthStateForgotPassword(
            exception: null,
            hasSentEmail: false,
            isLoading: true,
          ));

          Exception? exception;
          bool hasSentEmail;

          try {
            await provider.sendPasswordReset(email: email);
            exception = null;
            hasSentEmail = true;
          } on Exception catch (e) {
            exception = e;
            hasSentEmail = false;
          }

          emit(AuthStateForgotPassword(
              exception: exception,
              hasSentEmail: hasSentEmail,
              isLoading: false));
        }
      },
    );
  }
}
