import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/domain/repositories/address_repository.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';
import 'package:user_management_app/domain/usecases/users/delete_user_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockAddressRepository extends Mock implements AddressRepository {}

class AddressEntityFake extends Fake implements AddressEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(AddressEntityFake());
  });
  late DeleteUserUsecase usecase;
  late MockUserRepository mockUserRepository;
  late MockAddressRepository mockAddressRepository;

  final tUserId = 'user1';
  final tAddresses = [
    AddressEntity(
        id: '1',
        userId: tUserId,
        street: 'Street 1',
        neighborhood: 'Neighborhood 1',
        city: 'City',
        state: 'State',
        postalCode: '12345',
        label: 'Home',
        isPrimary: true),
    AddressEntity(
        id: '2',
        userId: tUserId,
        street: 'Street 2',
        neighborhood: 'Neighborhood 2',
        city: 'City',
        state: 'State',
        postalCode: '67890',
        label: 'Office',
        isPrimary: false),
  ];

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockAddressRepository = MockAddressRepository();
    usecase = DeleteUserUsecase(mockUserRepository, mockAddressRepository);
  });
  test('should delete all user addresses and then the user', () async {
    // arrange
    when(() => mockAddressRepository.getAddressesByUser(any()))
        .thenAnswer((_) async => Right(tAddresses));

    when(() => mockAddressRepository.deleteAddress(any()))
        .thenAnswer((_) async => const Right(null));

    when(() => mockUserRepository.deleteUser(any()))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tUserId);

    // assert
    expect(result, const Right(null));
    verify(() => mockAddressRepository.getAddressesByUser(tUserId)).called(1);
    verify(() => mockAddressRepository.deleteAddress('1')).called(1);
    verify(() => mockAddressRepository.deleteAddress('2')).called(1);
    verify(() => mockUserRepository.deleteUser(tUserId)).called(1);
  });

  test('should delete user directly if no addresses', () async {
    // arrange
    when(() => mockAddressRepository.getAddressesByUser(any()))
        .thenAnswer((_) async => const Right([]));

    when(() => mockUserRepository.deleteUser(any()))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tUserId);

    // assert
    expect(result, const Right(null));
    verify(() => mockAddressRepository.getAddressesByUser(tUserId)).called(1);
    verifyNever(() => mockAddressRepository.deleteAddress(any()));
    verify(() => mockUserRepository.deleteUser(tUserId)).called(1);
  });
  test('should delete user even if fetching addresses fails', () async {
    // arrange
    when(() => mockAddressRepository.getAddressesByUser(any())).thenAnswer(
        (_) async => Left(CacheFailure('Error fetching addresses')));

    when(() => mockUserRepository.deleteUser(any()))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tUserId);

    // assert
    expect(result, const Right(null));
    verify(() => mockAddressRepository.getAddressesByUser(tUserId)).called(1);
    verifyNever(() => mockAddressRepository.deleteAddress(any()));
    verify(() => mockUserRepository.deleteUser(tUserId)).called(1);
  });
  test('should return Left(Failure) if deleting user fails', () async {
    // arrange
    when(() => mockAddressRepository.getAddressesByUser(any()))
        .thenAnswer((_) async => const Right([]));

    when(() => mockUserRepository.deleteUser(any()))
        .thenAnswer((_) async => Left(CacheFailure('Delete user error')));

    // act
    final result = await usecase(tUserId);

    // assert
    result.fold(
      (failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, 'Delete user error');
      },
      (_) => fail('Expected failure but got success'),
    );

    verify(() => mockAddressRepository.getAddressesByUser(tUserId)).called(1);
    verifyNever(() => mockAddressRepository.deleteAddress(any()));
    verify(() => mockUserRepository.deleteUser(tUserId)).called(1);
  });
}
