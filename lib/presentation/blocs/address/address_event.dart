part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAddressesEvent extends AddressEvent {
  final String userId;

  LoadAddressesEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class DeleteAddressEvent extends AddressEvent {
  final String id;
  final String userId;

  DeleteAddressEvent({
    required this.id,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, userId];
}

class SetPrimaryAddressEvent extends AddressEvent {
  final String id;
  final String userId;

  SetPrimaryAddressEvent({
    required this.id,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, userId];
}
