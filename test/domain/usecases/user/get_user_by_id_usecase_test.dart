import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/domain/usecases/users/get_user_by_id_usecase.dart';

// Mock de UserRepository
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUserByIdUsecase usecase;
  late MockUserRepository mockUserRepository;

  final tUserId = '1';
  final tUser = UserEntity(
    id: tUserId,
    firstName: 'Hanuar',
    lastName: 'Rubio',
    email: 'hanuar@test.com',
    phone: '3001234567',
    birthDate: DateTime(1999, 4, 19),
  );

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUserByIdUsecase(mockUserRepository);
  });

  test('should return UserEntity when repository succeeds', () async {
    // arrange
    when(() => mockUserRepository.getUserById(any()))
        .thenAnswer((_) async => Right(tUser));

    // act
    final result = await usecase(tUserId);

    // assert
    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Expected Right but got Left'),
      (user) {
        expect(user, tUser);
      },
    );
    verify(() => mockUserRepository.getUserById(tUserId)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return Failure when repository fails', () async {
    // arrange
    when(() => mockUserRepository.getUserById(any()))
        .thenAnswer((_) async => Left(CacheFailure('User not found')));

    // act
    final result = await usecase(tUserId);

    // assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, 'User not found');
      },
      (_) => fail('Expected Left but got Right'),
    );
    verify(() => mockUserRepository.getUserById(tUserId)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
