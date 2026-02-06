import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/core/validators/address_validators.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/domain/usecases/addresses/save_address_usecase.dart';
import 'package:user_management_app/domain/usecases/addresses/update_address_usecase.dart';
import 'package:uuid/uuid.dart';

part 'address_form_event.dart';
part 'address_form_state.dart';

class AddressFormBloc extends Bloc<AddressFormEvent, AddressFormState> {
  final SaveAddressUsecase saveAddress;
  final UpdateAddressUsecase updateAddress;

  AddressFormBloc({
    required this.saveAddress,
    required this.updateAddress,
    AddressEntity? address,
  }) : super(AddressFormState(
          street: address?.street ?? '',
          neighborhood: address?.neighborhood ?? '',
          city: address?.city ?? '',
          state: address?.state ?? '',
          postalCode: address?.postalCode ?? '',
          label: address?.label ?? '',
          isPrimary: address?.isPrimary ?? false,
          isValid: address != null &&
              AddressValidators.validateStreet(address.street) == null &&
              AddressValidators.validateNeighborhood(address.neighborhood) ==
                  null &&
              AddressValidators.validateCity(address.city) == null &&
              AddressValidators.validateState(address.state) == null &&
              AddressValidators.validatePostalCode(address.postalCode) == null,
        )) {
    on<StreetChanged>(_onValidate);
    on<NeighborhoodChanged>(_onValidate);
    on<CityChanged>(_onValidate);
    on<StateChanged>(_onValidate);
    on<PostalCodeChanged>(_onValidate);
    on<LabelChanged>(_onValidate);
    on<PrimaryChanged>(_onValidate);

    on<SubmitAddressForm>(_onSubmit);
  }

  void _onValidate(
    AddressFormEvent event,
    Emitter<AddressFormState> emit,
  ) {
    final newState = _mapEventToState(event, state);
    String? streetError = state.streetError;
    String? neighborhoodError = state.neighborhoodError;
    String? cityError = state.cityError;
    String? stateError = state.stateError;
    String? postalCodeError = state.postalCodeError;

    if (event is StreetChanged) {
      streetError = AddressValidators.validateStreet(newState.street);
    }

    if (event is NeighborhoodChanged) {
      neighborhoodError =
          AddressValidators.validateNeighborhood(newState.neighborhood);
    }

    if (event is CityChanged) {
      cityError = AddressValidators.validateCity(newState.city);
    }

    if (event is StateChanged) {
      stateError = AddressValidators.validateState(newState.state);
    }

    if (event is PostalCodeChanged) {
      postalCodeError =
          AddressValidators.validatePostalCode(newState.postalCode);
    }

    final isValid = [
      streetError,
      neighborhoodError,
      cityError,
      stateError,
      postalCodeError
    ].every((error) => error == null);

    emit(
      newState.copyWith(
        streetError: streetError,
        neighborhoodError: neighborhoodError,
        cityError: cityError,
        stateError: stateError,
        postalCodeError: postalCodeError,
        isValid: isValid,
      ),
    );
  }

  AddressFormState _mapEventToState(
    AddressFormEvent event,
    AddressFormState state,
  ) {
    if (event is StreetChanged) {
      return state.copyWith(street: event.value);
    }
    if (event is NeighborhoodChanged) {
      return state.copyWith(neighborhood: event.value);
    }
    if (event is CityChanged) {
      return state.copyWith(city: event.value);
    }
    if (event is StateChanged) {
      return state.copyWith(state: event.value);
    }
    if (event is PostalCodeChanged) {
      return state.copyWith(postalCode: event.value);
    }
    if (event is LabelChanged) {
      return state.copyWith(label: event.value);
    }
    if (event is PrimaryChanged) {
      return state.copyWith(isPrimary: event.value);
    }

    return state;
  }

  Future<void> _onSubmit(
    SubmitAddressForm event,
    Emitter<AddressFormState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    final address = AddressEntity(
      id: event.addressId ?? const Uuid().v4(),
      userId: event.userId,
      street: state.street,
      neighborhood: state.neighborhood,
      city: state.city,
      state: state.state,
      postalCode: state.postalCode,
      label: state.label,
      isPrimary: state.isPrimary,
    );

    final result = event.addressId == null
        ? await saveAddress(address)
        : await updateAddress(address);

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        isSubmitting: false,
        isSuccess: true,
      )),
    );
  }
}
