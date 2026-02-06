import 'package:dartz/dartz.dart';
import 'package:user_management_app/data/mappers/user_mapper.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

import '../datasources/user_local_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    try {
      final users = await localDataSource.getUsers();
      return Right(users.map((e) => UserMapper.toEntity(e)).toList());
    } catch (e) {
      return Left(CacheFailure("Error obteniendo usuarios"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String id) async {
    try {
      final user = await localDataSource.getUserById(id);

      if (user == null) {
        return Left(CacheFailure("Usuario no encontrado"));
      }

      return Right(UserMapper.toEntity(user));
    } catch (e) {
      return Left(CacheFailure("Error obteniendo usuario"));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(UserEntity user) async {
    try {
      final model = UserMapper.toModel(user);
      await localDataSource.saveUser(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure("Error guardando usuario"));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(UserEntity user) async {
    try {
      final model = UserMapper.toModel(user);
      await localDataSource.updateUser(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure("Error actualizando usuario"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      await localDataSource.deleteUser(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure("Error eliminando usuario"));
    }
  }
}
