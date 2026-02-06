import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/core/usecases/usecase.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/domain/usecases/users/delete_user_usecase.dart';
import 'package:user_management_app/domain/usecases/users/get_users_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUsecase getUsersUsecase;
  final DeleteUserUsecase deleteUserUsecase;

  UserBloc({
    required this.getUsersUsecase,
    required this.deleteUserUsecase,
  }) : super(UserInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(
      LoadUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await getUsersUsecase(NoParams());

    result.fold(
      (failure) => emit(UserError(failure.message)),
      (users) => emit(UserLoaded(users)),
    );
  }

  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await deleteUserUsecase(event.id);
    result.fold(
      (failure) => emit(UserActionFailure(failure.message)),
      (_) => emit(const UserActionSuccess()),
    );

    add(LoadUsersEvent());
  }
}
