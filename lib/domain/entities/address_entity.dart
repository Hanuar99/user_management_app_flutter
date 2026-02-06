import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String userId;

  final String street;
  final String neighborhood;
  final String city;
  final String state;
  final String postalCode;

  final String label; // Home, Work, Other
  final bool isPrimary;

  const AddressEntity({
    required this.id,
    required this.userId,
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.label,
    required this.isPrimary,
  });

  AddressEntity copyWith({
    String? id,
    String? userId,
    String? street,
    String? neighborhood,
    String? city,
    String? state,
    String? postalCode,
    String? label,
    bool? isPrimary,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      street: street ?? this.street,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      label: label ?? this.label,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        street,
        neighborhood,
        city,
        state,
        postalCode,
        label,
        isPrimary,
      ];
}
