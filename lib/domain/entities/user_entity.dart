import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String email;
  final String phone;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, birthDate, email, phone];
}
