import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/core/usecases/usecase.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';

class GetUserByIdUsecase implements UseCase<UserEntity, String> {
  final UserRepository repository;

  GetUserByIdUsecase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(String id) {
    return repository.getUserById(id);
  }
}
