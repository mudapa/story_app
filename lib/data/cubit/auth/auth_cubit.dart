import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/user_model.dart';
import '../../services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await AuthService().login(
        email: email,
        password: password,
      );
      emit(AuthSuccess(user));
    } on SocketException {
      emit(const AuthFailed(message: 'No internet connection'));
    } catch (e) {
      emit(AuthFailed(message: e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await AuthService().register(
        name: name,
        email: email,
        password: password,
      );
      emit(RegisterSuccess(user));
    } on SocketException {
      emit(const AuthFailed(message: 'No internet connection'));
    } catch (e) {
      emit(RegisterFailed(message: e.toString()));
    }
  }
}
