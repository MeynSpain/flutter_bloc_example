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
            floatingActionButton: BlocConsumer<CounterBloc, int>(
              listenWhen: (prev, current) => prev > current,
              listener: (context, state) {
                if (state == 0) {
                  Scaffold.of(context).showBottomSheet((context) => Container(
                        color: Colors.blue,
                        width: double.infinity,
                        height: 30,
                        child: Text('State is 0'),
                      ));
                }
              },
              builder: (context, state) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${state}'),
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
                        userBloc.add(UserGetUsersEvent(
                            context.read<CounterBloc>().state));
                      },
                      icon: const Icon(Icons.person)),
                  IconButton(
                      onPressed: () {
                        final userBloc = context.read<UserBloc>();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: userBloc,
                                child: Job(),
                              ),
                            ));

                        userBloc.add(UserGetUsersJobEvent(
                            context.read<CounterBloc>().state));
                      },
                      icon: const Icon(Icons.work)),
                ],
              ),
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
                  ],
                ),
              ),
            ));
      }),
    );
  }
}

class Job extends StatelessWidget {
  const Job({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<UserBloc, UserState>(
        // bloc: userBloc,
        builder: (context, state) {
          final users = state.users;
          final jobs = state.jobs;
          return Column(
            children: [
              if (state.isLoading) const CircularProgressIndicator(),
              if (jobs.isNotEmpty)
                ...state.jobs.map((e) => Text(
                      '${e.id} : ${e.name}',
                      style: TextStyle(fontSize: 26),
                    )),
            ],
          );
        },
      ),
    );
  }
}
