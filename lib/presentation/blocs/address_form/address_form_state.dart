part of 'address_form_bloc.dart';

class AddressFormState extends Equatable {
  final String street;
  final String neighborhood;
  final String city;
  final String state;
  final String postalCode;
  final String label;
  final bool isPrimary;

  final String? streetError;
  final String? neighborhoodError;
  final String? cityError;
  final String? stateError;
  final String? postalCodeError;

  final bool isValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const AddressFormState({
    this.street = '',
    this.neighborhood = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.label = 'Casa',
    this.isPrimary = false,
    this.streetError,
    this.neighborhoodError,
    this.cityError,
    this.stateError,
    this.postalCodeError,
    this.isValid = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  AddressFormState copyWith({
    String? street,
    String? neighborhood,
    String? city,
    String? state,
    String? postalCode,
    String? label,
    bool? isPrimary,
    String? streetError,
    String? neighborhoodError,
    String? cityError,
    String? stateError,
    String? postalCodeError,
    bool? isValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return AddressFormState(
      street: street ?? this.street,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      label: label ?? this.label,
      isPrimary: isPrimary ?? this.isPrimary,
      streetError: streetError,
      neighborhoodError: neighborhoodError,
      cityError: cityError,
      stateError: stateError,
      postalCodeError: postalCodeError,
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        street,
        neighborhood,
        city,
        state,
        postalCode,
        label,
        isPrimary,
        streetError,
        neighborhoodError,
        cityError,
        stateError,
        postalCodeError,
        isValid,
        isSubmitting,
        isSuccess,
        errorMessage,
      ];
}
