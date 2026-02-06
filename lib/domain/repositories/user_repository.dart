import 'package:dartz/dartz.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import '../../core/errors/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers();

  Future<Either<Failure, UserEntity>> getUserById(String id);

  Future<Either<Failure, void>> saveUser(UserEntity user);

  Future<Either<Failure, void>> updateUser(UserEntity user);

  Future<Either<Failure, void>> deleteUser(String id);
}
