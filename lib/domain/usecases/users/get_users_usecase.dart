import 'package:dartz/dartz.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/user_repository.dart';

class GetUsersUsecase implements UseCase<List<UserEntity>, NoParams> {
  final UserRepository repository;

  GetUsersUsecase(this.repository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(NoParams params) {
    return repository.getUsers();
  }
}
