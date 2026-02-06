import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/domain/repositories/address_repository.dart';
import 'package:user_management_app/domain/usecases/addresses/set_primary_address_usecase.dart';

class SetPrimaryAddressParamsFake extends Fake
    implements SetPrimaryAddressParams {}

class MockAddressRepository extends Mock implements AddressRepository {}

void main() {
  late MockAddressRepository mockAddressRepository;
  late SetPrimaryAddressUsecase usecase;

  const tId = '1';
  const tUserId = 'user1';
  final tParams = SetPrimaryAddressParams(id: tId, userId: tUserId);

  setUpAll(() {
    registerFallbackValue(SetPrimaryAddressParamsFake());
  });

  setUp(() {
    mockAddressRepository = MockAddressRepository();
    usecase = SetPrimaryAddressUsecase(mockAddressRepository);
  });

  test('should return Right(void) when setting primary address succeeds',
      () async {
    // arrange
    when(() => mockAddressRepository.setPrimaryAddress(any(), any()))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result.isRight(), true);
    verify(() => mockAddressRepository.setPrimaryAddress(tId, tUserId))
        .called(1);
  });

  test('should return Left(Failure) when setting primary address fails',
      () async {
    // arrange
    when(() => mockAddressRepository.setPrimaryAddress(any(), any()))
        .thenAnswer((_) async => Left(CacheFailure('Set primary error')));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure.message, 'Set primary error'),
      (_) => fail('Expected Left(Failure), got Right'),
    );
    verify(() => mockAddressRepository.setPrimaryAddress(tId, tUserId))
        .called(1);
  });
}
