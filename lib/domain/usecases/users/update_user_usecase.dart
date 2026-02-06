import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/core/usecases/usecase.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';

class UpdateUserUsecase implements UseCase<void, UserEntity> {
  final UserRepository repository;

  UpdateUserUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(UserEntity user) {
    return repository.updateUser(user);
  }
}
