import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_example/counter_bloc.dart';
import 'package:flutter_bloc_example/user_bloc/user_bloc.dart';
// import 'package:flutter_bloc_1/counter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterBloc = CounterBloc();
    // final userBloc = UserBloc();

    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc>(
          create: (context) => counterBloc,
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(counterBloc: counterBloc),
        ),
      ],
      child: Builder(builder: (context) {
        // final counterBloc = context.watch<CounterBloc>();
        final counterBloc = BlocProvider.of<CounterBloc>(context);
        // final userBloc = context.watch<UserBloc>();
        return Scaffold(
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      counterBloc.add(CounterIncrementEvent());
                    },
                    icon: const Icon(Icons.plus_one)),
                IconButton(
                    onPressed: () {
                      counterBloc.add(CounterDecrementEvent());
                    },
                    icon: const Icon(Icons.exposure_minus_1)),
                IconButton(
                    onPressed: () {
                      final userBloc = context.read<UserBloc>();
                      userBloc.add(
                          UserGetUsersEvent(context.read<CounterBloc>().state));
                    },
                    icon: const Icon(Icons.person)),
                IconButton(
                    onPressed: () {
                      final userBloc = context.read<UserBloc>();
                      userBloc.add(UserGetUsersJobEvent(
                          context.read<CounterBloc>().state));
                    },
                    icon: const Icon(Icons.work)),
              ],
            ),
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    BlocBuilder<CounterBloc, int>(
                      // bloc: counterBloc,
                      builder: (context, state) {
                        final users =
                            context.select((UserBloc bloc) => bloc.state.users);
                        return Column(
                          children: [
                            Text(
                              state.toString(),
                              style: const TextStyle(fontSize: 36),
                            ),
                            if (users.isNotEmpty)
                              ...users.map((e) => Text(
                                    '${e.id} : ${e.name}',
                                    style: TextStyle(fontSize: 26),
                                  )),
                          ],
                        );
                      },
                    ),
                    BlocBuilder<UserBloc, UserState>(
                      // bloc: userBloc,
                      builder: (context, state) {
                        final users = state.users;
                        final jobs = state.jobs;
                        return Column(
                          children: [
                            if (state.isLoading)
                              const CircularProgressIndicator(),
                            // if (users.isNotEmpty)
                            //   ...state.users.map((e) => Text(
                            //         '${e.id} : ${e.name}',
                            //         style: TextStyle(fontSize: 26),
                            //       )),
                            if (jobs.isNotEmpty)
                              ...state.jobs.map((e) => Text(
                                    '${e.id} : ${e.name}',
                                    style: TextStyle(fontSize: 26),
                                  )),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ));
      }),
    );
  }
}
