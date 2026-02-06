part of 'user_bloc.dart';

abstract class UserEvent {}

class LoadUsersEvent extends UserEvent {}

class DeleteUserEvent extends UserEvent {
  final String id;

  DeleteUserEvent(this.id);
}
