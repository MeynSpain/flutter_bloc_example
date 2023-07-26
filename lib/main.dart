import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_example/counter_bloc.dart';
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
    return BlocProvider<CounterBloc>(
      create: (context) => counterBloc,
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  counterBloc.add(CounterIncrementEvent());
                },
                icon: Icon(Icons.plus_one)
            ),
            IconButton(
                onPressed: () {
                  counterBloc.add(CounterDecrementEvent());
                },
                icon: Icon(Icons.exposure_minus_1)
            ),
          ],
        ),
        body: BlocBuilder<CounterBloc, int>(
          bloc: counterBloc,
          builder: (context, state) {
            return Center(
              child: Text(state.toString(),
                style: TextStyle(fontSize: 36),
              ),
            );
          },
        ),
      ),
    );
  }
}
