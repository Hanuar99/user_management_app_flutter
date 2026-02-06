import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/core/usecases/usecase.dart';
import 'package:user_management_app/domain/repositories/address_repository.dart';

class DeleteAddressUsecase implements UseCase<void, String> {
  final AddressRepository repository;

  DeleteAddressUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteAddress(id);
  }
}
