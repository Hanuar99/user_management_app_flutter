import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/core/usecases/usecase.dart';
import 'package:user_management_app/domain/usecases/users/get_users_usecase.dart'; // para NoParams

// Mock de UserRepository
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUsersUsecase usecase;
  late MockUserRepository mockUserRepository;

  final tUsers = [
    UserEntity(
      id: '1',
      firstName: 'Hanuar',
      lastName: 'Rubio',
      email: 'hanuar@test.com',
      phone: '3001234567',
      birthDate: DateTime(1999, 4, 19),
    ),
    UserEntity(
      id: '2',
      firstName: 'Juan',
      lastName: 'Perez',
      email: 'juan@test.com',
      phone: '3007654321',
      birthDate: DateTime(1995, 7, 10),
    ),
  ];

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUsersUsecase(mockUserRepository);
  });

  test('should return a list of UserEntity when repository succeeds', () async {
    // arrange
    when(() => mockUserRepository.getUsers())
        .thenAnswer((_) async => Right(tUsers));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Expected Right but got Left'),
      (users) {
        expect(users, tUsers);
      },
    );
    verify(() => mockUserRepository.getUsers()).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return Failure when repository fails', () async {
    // arrange
    when(() => mockUserRepository.getUsers())
        .thenAnswer((_) async => Left(CacheFailure('Unable to fetch users')));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, 'Unable to fetch users');
      },
      (_) => fail('Expected Left but got Right'),
    );
    verify(() => mockUserRepository.getUsers()).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
