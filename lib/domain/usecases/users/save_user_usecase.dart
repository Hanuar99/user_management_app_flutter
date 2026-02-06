import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/core/usecases/usecase.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';

class SaveUserUsecase implements UseCase<void, UserEntity> {
  final UserRepository repository;

  SaveUserUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(UserEntity user) {
    return repository.saveUser(user);
  }
}
