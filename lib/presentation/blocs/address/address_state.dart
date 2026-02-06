part of 'address_bloc.dart';

abstract class AddressState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<AddressEntity> addresses;

  AddressLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class AddressError extends AddressState {
  final String message;

  AddressError(this.message);

  @override
  List<Object?> get props => [message];
}

class AddressActionSuccess extends AddressState {}

class AddressActionFailure extends AddressState {
  final String message;

  AddressActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
