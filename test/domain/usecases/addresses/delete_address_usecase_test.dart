import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/domain/repositories/address_repository.dart';
import 'package:user_management_app/domain/usecases/addresses/delete_address_usecase.dart';

class MockAddressRepository extends Mock implements AddressRepository {}

void main() {
  late MockAddressRepository mockAddressRepository;
  late DeleteAddressUsecase usecase;

  const tAddressId = '1';

  setUp(() {
    mockAddressRepository = MockAddressRepository();
    usecase = DeleteAddressUsecase(mockAddressRepository);
  });

  test('should return Right(void) when deleteAddress succeeds', () async {
    // arrange
    when(() => mockAddressRepository.deleteAddress(any()))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tAddressId);

    // assert
    expect(result.isRight(), true);
    verify(() => mockAddressRepository.deleteAddress(tAddressId)).called(1);
  });

  test('should return Left(Failure) when deleteAddress fails', () async {
    // arrange
    when(() => mockAddressRepository.deleteAddress(any()))
        .thenAnswer((_) async => Left(CacheFailure('Delete error')));

    // act
    final result = await usecase(tAddressId);

    // assert
    expect(result.isLeft(), true);
    verify(() => mockAddressRepository.deleteAddress(tAddressId)).called(1);
  });
}
