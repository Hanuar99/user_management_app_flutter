import 'package:dartz/dartz.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';

import '../../core/errors/failures.dart';
import '../../domain/repositories/address_repository.dart';

import '../datasources/address_local_datasource.dart';
import '../mappers/address_mapper.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressLocalDataSource localDataSource;

  AddressRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddressesByUser(
      String userId) async {
    try {
      final models = await localDataSource.getAddressesByUser(userId);

      return Right(
        models.map(AddressMapper.toEntity).toList(),
      );
    } catch (_) {
      return Left(CacheFailure("Error loading addresses"));
    }
  }

  @override
  Future<Either<Failure, void>> saveAddress(AddressEntity address) async {
    try {
      await localDataSource.saveAddress(
        AddressMapper.toModel(address),
      );
      return const Right(null);
    } catch (_) {
      return Left(CacheFailure("Error saving address"));
    }
  }

  @override
  Future<Either<Failure, void>> updateAddress(AddressEntity address) async {
    try {
      await localDataSource.updateAddress(
        AddressMapper.toModel(address),
      );
      return const Right(null);
    } catch (_) {
      return Left(CacheFailure("Error updating address"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String id) async {
    try {
      await localDataSource.deleteAddress(id);
      return const Right(null);
    } catch (_) {
      return Left(CacheFailure("Error deleting address"));
    }
  }

  @override
  Future<Either<Failure, void>> setPrimaryAddress(
      String id, String userId) async {
    try {
      await localDataSource.setPrimaryAddress(id, userId);
      return const Right(null);
    } catch (_) {
      return Left(CacheFailure("Error setting primary address"));
    }
  }
}
