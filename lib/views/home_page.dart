import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zapys/services/auth/bloc/auth_bloc.dart';
import 'package:zapys/services/auth/bloc/auth_event.dart';
import 'package:zapys/services/auth/bloc/auth_state.dart';
import 'package:zapys/views/login_view.dart';
import 'package:zapys/views/notes/notes_view.dart';
import 'package:zapys/views/register_view.dart';
import 'package:zapys/views/verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const NotesView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
    });
  }
}
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _textController;

//   @override
//   void initState() {
//     _textController = TextEditingController();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Testing bloc'),
//         ),
//         body: BlocConsumer<CounterBloc, CounterState>(
//           builder: ((context, state) {
//             final invalidValue =
//                 (state is CounterStateInvalidNumber) ? state.invalidValue : '';
//             return Column(
//               children: [
//                 Text(
//                   'Current value => ${state.value}',
//                 ),
//                 Visibility(
//                   child: Text('Invalid input $invalidValue'),
//                   visible: state is CounterStateInvalidNumber,
//                 ),
//                 TextField(
//                   controller: _textController,
//                   decoration: const InputDecoration(hintText: 'Enter number'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         context
//                             .read<CounterBloc>()
//                             .add(DecrementEvent(_textController.text));
//                       },
//                       child: const Text(' - '),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         context
//                             .read<CounterBloc>()
//                             .add(IncrementEvent(_textController.text));
//                       },
//                       child: const Text(' + '),
//                     ),
//                   ],
//                 )
//               ],
//             );
//           }),
//           listener: (context, state) {
//             _textController.clear();
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }
// }

// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }

// class CounterStateInvalidNumber extends CounterState {
//   final String invalidValue;
//   const CounterStateInvalidNumber({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }

// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(String value) : super(value);
// }

// class DecrementEvent extends CounterEvent {
//   const DecrementEvent(String value) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<IncrementEvent>(
//       ((event, emit) {
//         final integer = int.tryParse(event.value);
//         if (integer == null) {
//           emit(
//             CounterStateInvalidNumber(
//               invalidValue: event.value,
//               previousValue: state.value,
//             ),
//           );
//         } else {
//           emit(CounterStateValid(state.value + integer));
//         }
//       }),
//     );
//     on<DecrementEvent>(
//       ((event, emit) {
//         final integer = int.tryParse(event.value);
//         if (integer == null) {
//           emit(
//             CounterStateInvalidNumber(
//               invalidValue: event.value,
//               previousValue: state.value,
//             ),
//           );
//         } else {
//           emit(CounterStateValid(state.value - integer));
//         }
//       }),
//     );
//   }
// }
