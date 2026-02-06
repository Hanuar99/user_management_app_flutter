import 'package:hive/hive.dart';

part 'address_model.g.dart';

@HiveType(typeId: 1)
class AddressModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String street;

  @HiveField(3)
  final String neighborhood;

  @HiveField(4)
  final String city;

  @HiveField(5)
  final String state;

  @HiveField(6)
  final String postalCode;

  @HiveField(7)
  final String label;

  @HiveField(8)
  final bool isPrimary;

  AddressModel({
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
}
