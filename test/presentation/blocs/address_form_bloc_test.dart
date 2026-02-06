import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/domain/usecases/addresses/save_address_usecase.dart';
import 'package:user_management_app/domain/usecases/addresses/update_address_usecase.dart';
import 'package:user_management_app/presentation/blocs/address_form/address_form_bloc.dart';

class MockSaveAddressUsecase extends Mock implements SaveAddressUsecase {}

class MockUpdateAddressUsecase extends Mock implements UpdateAddressUsecase {}

void main() {
  late AddressFormBloc bloc;
  late MockSaveAddressUsecase mockSaveAddress;
  late MockUpdateAddressUsecase mockUpdateAddress;

  final tAddress = AddressEntity(
    id: '1',
    userId: 'user_1',
    street: 'Street 123',
    neighborhood: 'Neighborhood',
    city: 'City',
    state: 'State',
    postalCode: '12345',
    label: 'Home',
    isPrimary: true,
  );

  setUp(() {
    mockSaveAddress = MockSaveAddressUsecase();
    mockUpdateAddress = MockUpdateAddressUsecase();

    bloc = AddressFormBloc(
      saveAddress: mockSaveAddress,
      updateAddress: mockUpdateAddress,
      address: tAddress,
    );

    registerFallbackValue(tAddress);
  });

  group('Field validation', () {
    blocTest<AddressFormBloc, AddressFormState>(
      'should update street and validate correctly',
      build: () => bloc,
      act: (bloc) => bloc.add(StreetChanged('')),
      expect: () => [
        isA<AddressFormState>()
            .having((s) => s.street, 'street', '')
            .having((s) => s.streetError, 'error', isNotNull)
            .having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<AddressFormBloc, AddressFormState>(
      'should update city and validate correctly',
      build: () => bloc,
      act: (bloc) => bloc.add(CityChanged('City')),
      expect: () => [
        isA<AddressFormState>()
            .having((s) => s.city, 'city', 'City')
            .having((s) => s.cityError, 'error', isNull),
      ],
    );

    blocTest<AddressFormBloc, AddressFormState>(
      'should update postalCode and validate correctly',
      build: () => bloc,
      act: (bloc) => bloc.add(PostalCodeChanged('123')),
      expect: () => [
        isA<AddressFormState>()
            .having((s) => s.postalCode, 'postalCode', '123')
            .having((s) => s.postalCodeError, 'error', isNotNull)
            .having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<AddressFormBloc, AddressFormState>(
      'should update neighborhood and validate correctly',
      build: () => bloc,
      act: (bloc) => bloc.add(NeighborhoodChanged('')),
      expect: () => [
        isA<AddressFormState>()
            .having((s) => s.neighborhood, 'neighborhood', '')
            .having((s) => s.neighborhoodError, 'error', isNotNull)
            .having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<AddressFormBloc, AddressFormState>(
      'should update state and validate correctly',
      build: () => bloc,
      act: (bloc) => bloc.add(StateChanged('')),
      expect: () => [
        isA<AddressFormState>()
            .having((s) => s.state, 'state', '')
            .having((s) => s.stateError, 'error', isNotNull)
            .having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<AddressFormBloc, AddressFormState>(
      'should update isPrimary correctly',
      build: () => bloc,
      act: (bloc) => bloc.add(PrimaryChanged(true)),
      expect: () => [
        isA<AddressFormState>()
            .having((s) => s.isPrimary, 'isPrimary', true)
            .having((s) => s.isValid, 'isValid', true),
      ],
    );
    blocTest<AddressFormBloc, AddressFormState>(
      'should update label correctly',
      build: () => bloc,
      act: (bloc) => bloc.add(LabelChanged('Home')),
      expect: () => [
        isA<AddressFormState>()
            .having((s) => s.label, 'label', 'Home')
            .having((s) => s.isValid, 'isValid', true),
      ],
    );
  });

  group('Submit AddressForm', () {
    blocTest<AddressFormBloc, AddressFormState>(
      'should emit [isSubmitting true, isSuccess true] when saveAddress succeeds',
      build: () {
        when(() => mockSaveAddress(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(SubmitAddressForm(userId: 'user_1')),
      seed: () => bloc.state.copyWith(
        street: 'Street 123',
        neighborhood: 'Neighborhood',
        city: 'City',
        state: 'State',
        postalCode: '12345',
        label: 'Home',
        isPrimary: true,
        isValid: true,
      ),
      expect: () => [
        isA<AddressFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<AddressFormState>()
            .having((s) => s.isSuccess, 'isSuccess', true)
            .having((s) => s.isSubmitting, 'isSubmitting', false),
      ],
      verify: (_) => verify(() => mockSaveAddress(any())).called(1),
    );

    blocTest<AddressFormBloc, AddressFormState>(
      'should emit [isSubmitting true, errorMessage] when saveAddress fails',
      build: () {
        when(() => mockSaveAddress(any()))
            .thenAnswer((_) async => Left(CacheFailure('Save Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(SubmitAddressForm(userId: 'user_1')),
      seed: () => bloc.state.copyWith(
        street: 'Street 123',
        neighborhood: 'Neighborhood',
        city: 'City',
        state: 'State',
        postalCode: '12345',
        label: 'Home',
        isPrimary: true,
        isValid: true,
      ),
      expect: () => [
        isA<AddressFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<AddressFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having((s) => s.errorMessage, 'errorMessage', 'Save Error'),
      ],
      verify: (_) => verify(() => mockSaveAddress(any())).called(1),
    );

    blocTest<AddressFormBloc, AddressFormState>(
      'should call updateAddress if addressId is provided',
      build: () {
        when(() => mockUpdateAddress(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(SubmitAddressForm(userId: 'user_1', addressId: '1')),
      seed: () => bloc.state.copyWith(
        street: 'Street 123',
        neighborhood: 'Neighborhood',
        city: 'City',
        state: 'State',
        postalCode: '12345',
        label: 'Home',
        isPrimary: true,
        isValid: true,
      ),
      expect: () => [
        isA<AddressFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<AddressFormState>()
            .having((s) => s.isSuccess, 'isSuccess', true)
            .having((s) => s.isSubmitting, 'isSubmitting', false),
      ],
      verify: (_) => verify(() => mockUpdateAddress(any())).called(1),
    );
  });
}
