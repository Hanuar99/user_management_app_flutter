import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/domain/usecases/addresses/delete_address_usecase.dart';
import 'package:user_management_app/domain/usecases/addresses/get_address_by_user_usecase.dart';
import 'package:user_management_app/domain/usecases/addresses/set_primary_address_usecase.dart';
import 'package:user_management_app/presentation/blocs/address/address_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/errors/failures.dart';

// Mocks
class MockGetAddressByUserUseCase extends Mock
    implements GetAddressByUserUseCase {}

class MockDeleteAddressUsecase extends Mock implements DeleteAddressUsecase {}

class MockSetPrimaryAddressUsecase extends Mock
    implements SetPrimaryAddressUsecase {}

class SetPrimaryAddressParamsFake extends Fake
    implements SetPrimaryAddressParams {}

void main() {
  late AddressBloc bloc;
  late MockGetAddressByUserUseCase mockGetAddresses;
  late MockDeleteAddressUsecase mockDeleteAddress;
  late MockSetPrimaryAddressUsecase mockSetPrimary;

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
    mockGetAddresses = MockGetAddressByUserUseCase();
    mockDeleteAddress = MockDeleteAddressUsecase();
    mockSetPrimary = MockSetPrimaryAddressUsecase();

    bloc = AddressBloc(
      getAddressesByUser: mockGetAddresses,
      deleteAddress: mockDeleteAddress,
      setPrimaryAddress: mockSetPrimary,
    );

    registerFallbackValue(tAddresses[0]);
    registerFallbackValue(SetPrimaryAddressParamsFake());
  });

  group('LoadAddressesEvent', () {
    blocTest<AddressBloc, AddressState>(
      'emits [AddressLoading, AddressLoaded] when getAddressesByUser succeeds',
      build: () {
        when(() => mockGetAddresses(any()))
            .thenAnswer((_) async => Right(tAddresses));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAddressesEvent(tUserId)),
      expect: () => [
        isA<AddressLoading>(),
        isA<AddressLoaded>()
            .having((s) => s.addresses, 'addresses', tAddresses),
      ],
      verify: (_) => verify(() => mockGetAddresses(tUserId)).called(1),
    );

    blocTest<AddressBloc, AddressState>(
      'emits [AddressLoading, AddressError] when getAddressesByUser fails',
      build: () {
        when(() => mockGetAddresses(any()))
            .thenAnswer((_) async => Left(CacheFailure('Load Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAddressesEvent(tUserId)),
      expect: () => [
        isA<AddressLoading>(),
        isA<AddressError>().having((s) => s.message, 'message', 'Load Error'),
      ],
      verify: (_) => verify(() => mockGetAddresses(tUserId)).called(1),
    );
  });

  group('DeleteAddressEvent', () {
    blocTest<AddressBloc, AddressState>(
      'emits [AddressLoading, AddressActionSuccess, AddressLoading, AddressLoaded] on success',
      build: () {
        when(() => mockDeleteAddress(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetAddresses(any()))
            .thenAnswer((_) async => Right(tAddresses));
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteAddressEvent(id: '1', userId: tUserId)),
      expect: () => [
        isA<AddressLoading>(), // delete start
        isA<AddressActionSuccess>(), // delete success
        isA<AddressLoading>(), // reload start
        isA<AddressLoaded>().having(
            (s) => s.addresses, 'addresses', tAddresses), // reload success
      ],
      verify: (_) {
        verify(() => mockDeleteAddress('1')).called(1);
        verify(() => mockGetAddresses(tUserId)).called(1);
      },
    );

    blocTest<AddressBloc, AddressState>(
      'emits [AddressLoading, AddressActionFailure, AddressLoading, AddressLoaded] when delete fails',
      build: () {
        when(() => mockDeleteAddress(any()))
            .thenAnswer((_) async => Left(CacheFailure('Delete Error')));
        when(() => mockGetAddresses(any()))
            .thenAnswer((_) async => Right(tAddresses));
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteAddressEvent(id: '1', userId: tUserId)),
      expect: () => [
        isA<AddressLoading>(),
        isA<AddressActionFailure>()
            .having((s) => s.message, 'message', 'Delete Error'),
        isA<AddressLoading>(),
        isA<AddressLoaded>(),
      ],
      verify: (_) => verify(() => mockDeleteAddress('1')).called(1),
    );
  });

  group('SetPrimaryAddressEvent', () {
    blocTest<AddressBloc, AddressState>(
      'calls setPrimaryAddress and then loads addresses on success',
      build: () {
        when(() => mockSetPrimary(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockGetAddresses(any()))
            .thenAnswer((_) async => Right(tAddresses));
        return bloc;
      },
      act: (bloc) => bloc.add(SetPrimaryAddressEvent(id: '2', userId: tUserId)),
      expect: () => [
        // primero se dispara la carga interna de LoadAddressesEvent
        isA<AddressLoading>(),
        // luego el resultado del LoadAddressesEvent
        isA<AddressLoaded>()
            .having((s) => s.addresses, 'addresses', tAddresses),
      ],
      verify: (_) {
        verify(() => mockSetPrimary(any())).called(1);
        verify(() => mockGetAddresses(tUserId)).called(1);
      },
    );

    blocTest<AddressBloc, AddressState>(
      'emits AddressError when setPrimaryAddress fails',
      build: () {
        when(() => mockSetPrimary(any()))
            .thenAnswer((_) async => Left(CacheFailure('Set Primary Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(SetPrimaryAddressEvent(id: '2', userId: tUserId)),
      expect: () => [
        isA<AddressError>()
            .having((s) => s.message, 'message', 'Set Primary Error'),
      ],
      verify: (_) {
        verify(() => mockSetPrimary(any())).called(1);
      },
    );
  });
}
