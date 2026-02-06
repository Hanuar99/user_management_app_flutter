import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/core/usecases/usecase.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/domain/repositories/address_repository.dart';

class GetAddressByUserUseCase implements UseCase<List<AddressEntity>, String> {
  final AddressRepository repository;

  GetAddressByUserUseCase(this.repository);

  @override
  Future<Either<Failure, List<AddressEntity>>> call(String userId) {
    return repository.getAddressesByUser(userId);
  }
}
