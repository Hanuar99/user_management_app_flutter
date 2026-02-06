import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/core/usecases/usecase.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';

import 'package:user_management_app/domain/usecases/users/get_users_usecase.dart';
import 'package:user_management_app/domain/usecases/users/delete_user_usecase.dart';

import 'package:user_management_app/presentation/blocs/user/user_bloc.dart';

class MockGetUsersUsecase extends Mock implements GetUsersUsecase {}

class MockDeleteUserUsecase extends Mock implements DeleteUserUsecase {}

void main() {
  late UserBloc bloc;
  late MockGetUsersUsecase mockGetUsersUsecase;
  late MockDeleteUserUsecase mockDeleteUserUsecase;

  final UserEntity tUser = UserEntity(
    id: '1',
    firstName: 'Hanuar',
    lastName: 'Rubio',
    birthDate: DateTime(1999, 4, 19),
    email: 'hanuar@test.com',
    phone: '3001234567',
  );

  final List<UserEntity> tUsers = [tUser];

  setUp(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(tUser);

    mockGetUsersUsecase = MockGetUsersUsecase();
    mockDeleteUserUsecase = MockDeleteUserUsecase();

    bloc = UserBloc(
      getUsersUsecase: mockGetUsersUsecase,
      deleteUserUsecase: mockDeleteUserUsecase,
    );
  });

  group('UserBloc Tests >', () {
    blocTest<UserBloc, UserState>(
      'should load users successfully when LoadUsersEvent is added',
      build: () {
        when(() => mockGetUsersUsecase(any()))
            .thenAnswer((_) async => Right(tUsers));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadUsersEvent()),
      expect: () => [
        UserLoading(),
        UserLoaded(tUsers),
      ],
      verify: (_) {
        verify(() => mockGetUsersUsecase(any())).called(1);
      },
    );

    blocTest<UserBloc, UserState>(
      'should emit error state when loading users fails',
      build: () {
        when(() => mockGetUsersUsecase(any()))
            .thenAnswer((_) async => Left(CacheFailure("Error")));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadUsersEvent()),
      expect: () => [
        UserLoading(),
        UserError("Error"),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should delete user successfully and refresh list',
      build: () {
        when(() => mockDeleteUserUsecase('1'))
            .thenAnswer((_) async => const Right(null));

        when(() => mockGetUsersUsecase(any()))
            .thenAnswer((_) async => Right([]));

        return bloc;
      },
      act: (bloc) => bloc.add(DeleteUserEvent('1')),
      expect: () => [
        UserLoading(),
        UserActionSuccess(),
        UserLoading(),
        UserLoaded([]),
      ],
    );
    blocTest<UserBloc, UserState>(
      'should emit error state when deleting user fails',
      build: () {
        when(() => mockDeleteUserUsecase('1'))
            .thenAnswer((_) async => Left(CacheFailure("Delete Error")));
        when(() => mockGetUsersUsecase(any()))
            .thenAnswer((_) async => Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteUserEvent('1')),
      expect: () => [
        UserLoading(),
        UserActionFailure("Delete Error"),
        UserLoading(),
        UserLoaded([]),
      ],
    );
  });
}
