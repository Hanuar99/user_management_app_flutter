import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/domain/usecases/users/save_user_usecase.dart';

// Mock de UserRepository
class MockUserRepository extends Mock implements UserRepository {}

class UserEntityFake extends Fake implements UserEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(UserEntityFake());
  });

  late MockUserRepository mockUserRepository;
  late SaveUserUsecase usecase;
  final tUser = UserEntity(
    id: '1',
    firstName: 'Hanuar',
    lastName: 'Rubio',
    email: 'hanuar@test.com',
    phone: '3001234567',
    birthDate: DateTime(1999, 4, 19),
  );

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = SaveUserUsecase(mockUserRepository);
  });

  test('should return Right(void) when saving user succeeds', () async {
    // arrange
    when(() => mockUserRepository.saveUser(any()))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tUser);

    // assert
    expect(result.isRight(), true);
    verify(() => mockUserRepository.saveUser(tUser)).called(1);
  });

  test('should return Left(Failure) when saving user fails', () async {
    // arrange
    when(() => mockUserRepository.saveUser(any()))
        .thenAnswer((_) async => Left(CacheFailure('Save error')));

    // act
    final result = await usecase(tUser);

    // assert
    expect(result.isLeft(), true);
    verify(() => mockUserRepository.saveUser(tUser)).called(1);
  });
}
