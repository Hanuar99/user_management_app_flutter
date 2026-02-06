import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/domain/repositories/address_repository.dart';
import 'package:user_management_app/domain/usecases/addresses/get_address_by_user_usecase.dart';

// Mock del repository
class MockAddressRepository extends Mock implements AddressRepository {}

void main() {
  late MockAddressRepository mockAddressRepository;
  late GetAddressByUserUseCase usecase;

  const tUserId = 'user1';
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
      isPrimary: true,
    ),
    AddressEntity(
      id: '2',
      userId: tUserId,
      street: 'Street 2',
      neighborhood: 'Neighborhood 2',
      city: 'City',
      state: 'State',
      postalCode: '67890',
      label: 'Office',
      isPrimary: false,
    ),
  ];

  setUp(() {
    mockAddressRepository = MockAddressRepository();
    usecase = GetAddressByUserUseCase(mockAddressRepository);
  });

  test('should return Right(List<AddressEntity>) when repository succeeds',
      () async {
    // arrange
    when(() => mockAddressRepository.getAddressesByUser(any()))
        .thenAnswer((_) async => Right(tAddresses));

    // act
    final result = await usecase(tUserId);

    // assert
    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Expected a Right value, got Left'),
      (addresses) => expect(addresses, tAddresses),
    );
    verify(() => mockAddressRepository.getAddressesByUser(tUserId)).called(1);
  });

  test('should return Left(Failure) when repository fails', () async {
    // arrange
    when(() => mockAddressRepository.getAddressesByUser(any()))
        .thenAnswer((_) async => Left(CacheFailure('Get addresses error')));

    // act
    final result = await usecase(tUserId);

    // assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure.message, 'Get addresses error'),
      (_) => fail('Expected a Left value, got Right'),
    );
    verify(() => mockAddressRepository.getAddressesByUser(tUserId)).called(1);
  });
}
