import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_example/counter_bloc.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CounterBloc counterBloc;
  late final StreamSubscription counterBlocSubscription;

  UserBloc({required this.counterBloc}) : super(UserState()) {
    on<UserGetUsersEvent>(_onGetUsers);
    on<UserGetUsersJobEvent>(_onGetUsersJob);
    counterBlocSubscription = counterBloc.stream.listen((state) {
      if (state <= 0) {
        add(UserGetUsersEvent(0));
        add(UserGetUsersJobEvent(0));
      }
    });
  }

  Future<void> close() async {
    counterBlocSubscription.cancel();
    return super.close();
  }

  _onGetUsers(UserGetUsersEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true));
    // Иммитация запроса на сервер
    await Future.delayed(const Duration(seconds: 1));

    final List<User> users = List.generate(event.count, (index) => User(name: 'user name', id: index.toString()));
    emit(state.copyWith(isLoading: false, users: users));

  }

  _onGetUsersJob(UserGetUsersJobEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true));
    // Иммитация запроса на сервер
    await Future.delayed(const Duration(seconds: 1));

    final List<Job> jobs = List.generate(event.count, (index) => Job(name: 'Job name', id: index.toString()));
    emit(state.copyWith(isLoading: false, jobs: jobs));
  }
}
