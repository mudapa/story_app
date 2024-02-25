part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserModel user;

  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

final class AuthFailed extends AuthState {
  final String message;

  const AuthFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class RegisterSuccess extends AuthState {
  final UserModel user;

  const RegisterSuccess(this.user);

  @override
  List<Object> get props => [user];
}

final class RegisterFailed extends AuthState {
  final String message;

  const RegisterFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
