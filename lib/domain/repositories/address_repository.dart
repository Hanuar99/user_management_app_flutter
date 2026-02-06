import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddressesByUser(
      String userId);

  Future<Either<Failure, void>> saveAddress(AddressEntity address);

  Future<Either<Failure, void>> updateAddress(AddressEntity address);

  Future<Either<Failure, void>> deleteAddress(String id);

  Future<Either<Failure, void>> setPrimaryAddress(String id, String userId);
}
