part of 'address_form_bloc.dart';

abstract class AddressFormEvent {}

class StreetChanged extends AddressFormEvent {
  final String value;
  StreetChanged(this.value);
}

class NeighborhoodChanged extends AddressFormEvent {
  final String value;
  NeighborhoodChanged(this.value);
}

class CityChanged extends AddressFormEvent {
  final String value;
  CityChanged(this.value);
}

class StateChanged extends AddressFormEvent {
  final String value;
  StateChanged(this.value);
}

class PostalCodeChanged extends AddressFormEvent {
  final String value;
  PostalCodeChanged(this.value);
}

class LabelChanged extends AddressFormEvent {
  final String value;
  LabelChanged(this.value);
}

class PrimaryChanged extends AddressFormEvent {
  final bool value;
  PrimaryChanged(this.value);
}

class SubmitAddressForm extends AddressFormEvent {
  final String userId;
  final String? addressId;

  SubmitAddressForm({
    required this.userId,
    this.addressId,
  });
}
