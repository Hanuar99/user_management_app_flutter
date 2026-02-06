part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final List<UserEntity> users;

  const UserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserActionSuccess extends UserState {
  const UserActionSuccess();
}

class UserActionFailure extends UserState {
  final String message;
  const UserActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
