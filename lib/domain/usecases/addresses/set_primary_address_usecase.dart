import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/core/usecases/usecase.dart';
import 'package:user_management_app/domain/repositories/address_repository.dart';

class SetPrimaryAddressUsecase
    implements UseCase<void, SetPrimaryAddressParams> {
  final AddressRepository repository;

  SetPrimaryAddressUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(SetPrimaryAddressParams params) {
    return repository.setPrimaryAddress(params.id, params.userId);
  }
}

class SetPrimaryAddressParams {
  final String id;
  final String userId;

  SetPrimaryAddressParams({required this.id, required this.userId});
}
