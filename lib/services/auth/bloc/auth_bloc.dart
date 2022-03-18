import 'package:bloc/bloc.dart';
import 'package:zapys/services/auth/auth_provider.dart';
import 'package:zapys/services/auth/bloc/auth_event.dart';
import 'package:zapys/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>(
      ((event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut());
        } else if (user.isEmailVerified == false) {
          emit(const AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(user));
        }
      }),
    );
    on<AuthEventLogIn>(
      ((event, emit) async {
        emit(const AuthStateLoading());
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(
            email: email,
            password: password,
          );
          if (user.isEmailVerified == false) {
            emit(const AuthStateNeedsVerification());
          }
          emit(AuthStateLoggedIn(user));
        } on Exception catch (exception) {
          emit(AuthStateLoginFailed(exception));
        }
      }),
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          emit(const AuthStateLoading());
          await provider.logOut();
          emit(const AuthStateLoggedOut());
        } on Exception catch (exception) {
          emit(AuthStateLogoutFailed(exception));
        }
      },
    );
  }
}
