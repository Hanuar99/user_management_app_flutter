import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/domain/repositories/address_repository.dart';
import 'package:user_management_app/domain/usecases/addresses/update_address_usecase.dart';

class MockAddressRepository extends Mock implements AddressRepository {}

class AddressEntityFake extends Fake implements AddressEntity {}

void main() {
  late MockAddressRepository mockAddressRepository;
  late UpdateAddressUsecase usecase;

  final tAddress = AddressEntity(
    id: '1',
    userId: 'user1',
    street: 'Street 1',
    neighborhood: 'Neighborhood 1',
    city: 'City',
    state: 'State',
    postalCode: '12345',
    label: 'Home',
    isPrimary: true,
  );

  setUpAll(() {
    // Necesario si usamos any() en mocks con AddressEntity
    registerFallbackValue(tAddress);
  });

  setUp(() {
    mockAddressRepository = MockAddressRepository();
    usecase = UpdateAddressUsecase(mockAddressRepository);
  });

  test('should return Right(void) when updating address succeeds', () async {
    // arrange
    when(() => mockAddressRepository.updateAddress(any()))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tAddress);

    // assert
    expect(result.isRight(), true);
    verify(() => mockAddressRepository.updateAddress(tAddress)).called(1);
  });

  test('should return Left(Failure) when updating address fails', () async {
    // arrange
    when(() => mockAddressRepository.updateAddress(any()))
        .thenAnswer((_) async => Left(CacheFailure('Update error')));

    // act
    final result = await usecase(tAddress);

    // assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure.message, 'Update error'),
      (_) => fail('Expected Left(Failure), got Right'),
    );
    verify(() => mockAddressRepository.updateAddress(tAddress)).called(1);
  });
}
