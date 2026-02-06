import 'package:user_management_app/domain/entities/user_entity.dart';

import '../models/user_model.dart';

class UserMapper {
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      firstName: model.firstName,
      lastName: model.lastName,
      birthDate: model.birthDate,
      email: model.email,
      phone: model.phone,
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      birthDate: entity.birthDate,
      email: entity.email,
      phone: entity.phone,
    );
  }
}
