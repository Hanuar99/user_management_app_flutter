import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/domain/repositories/address_repository.dart';
import 'package:user_management_app/domain/usecases/addresses/save_address_usecase.dart';

class MockAddressRepository extends Mock implements AddressRepository {}

class AddressEntityFake extends Fake implements AddressEntity {}

void main() {
  late MockAddressRepository mockAddressRepository;
  late SaveAddressUsecase usecase;

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
    registerFallbackValue(AddressEntityFake());
  });

  setUp(() {
    mockAddressRepository = MockAddressRepository();
    usecase = SaveAddressUsecase(mockAddressRepository);
  });
  test('should return Right(void) when saving address succeeds', () async {
    // arrange
    when(() => mockAddressRepository.saveAddress(any()))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tAddress);

    // assert
    // Solo verificamos que sea Right, no necesitamos usar el valor
    expect(result.isRight(), true);

    // También podemos usar esta sintaxis de mocktail para verificar la llamada
    verify(() => mockAddressRepository.saveAddress(tAddress)).called(1);
  });

  test('should return Left(Failure) when saving address fails', () async {
    // arrange
    when(() => mockAddressRepository.saveAddress(any()))
        .thenAnswer((_) async => Left(CacheFailure('Save address error')));

    // act
    final result = await usecase(tAddress);

    // assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure.message, 'Save address error'),
      (_) => fail('Expected Left(Failure), got Right'),
    );
    verify(() => mockAddressRepository.saveAddress(tAddress)).called(1);
  });
}
