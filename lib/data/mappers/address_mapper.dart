import 'package:user_management_app/domain/entities/address_entity.dart';
import '../models/address_model.dart';

class AddressMapper {
  static AddressEntity toEntity(AddressModel model) {
    return AddressEntity(
      id: model.id,
      userId: model.userId,
      street: model.street,
      neighborhood: model.neighborhood,
      city: model.city,
      state: model.state,
      postalCode: model.postalCode,
      label: model.label,
      isPrimary: model.isPrimary,
    );
  }

  static AddressModel toModel(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      userId: entity.userId,
      street: entity.street,
      neighborhood: entity.neighborhood,
      city: entity.city,
      state: entity.state,
      postalCode: entity.postalCode,
      label: entity.label,
      isPrimary: entity.isPrimary,
    );
  }
}
