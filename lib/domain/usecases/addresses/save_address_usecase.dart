import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/core/usecases/usecase.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/domain/repositories/address_repository.dart';

class SaveAddressUsecase implements UseCase<void, AddressEntity> {
  final AddressRepository repository;

  SaveAddressUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddressEntity address) {
    return repository.saveAddress(address);
  }
}
