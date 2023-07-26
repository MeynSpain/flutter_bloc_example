import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncrementEvent>(_onIncrement);
    on<CounterDecrementEvent>(_onDecrement);
  }

  _onIncrement(CounterIncrementEvent event, Emitter<int> emit) {
    emit(state + 1);
  }

  _onDecrement(CounterDecrementEvent event, Emitter<int> emit) {
    if (state <= 0) {
      return;
    }

    emit(state - 1);
  }
}

abstract class CounterEvent {}

class CounterIncrementEvent extends CounterEvent {}

class CounterDecrementEvent extends CounterEvent {}
