import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState()) {
    on<UserGetUsersEvent>(_onGetUsers);
    on<UserGetUsersJobEvent>(_onGetUsersJob);
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
