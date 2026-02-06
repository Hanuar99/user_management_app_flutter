import 'package:dartz/dartz.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/core/usecases/usecase.dart';
import 'package:user_management_app/domain/repositories/address_repository.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';

class DeleteUserUsecase implements UseCase<void, String> {
  final UserRepository userRepository;
  final AddressRepository addressRepository;

  DeleteUserUsecase(this.userRepository, this.addressRepository);

  @override
  Future<Either<Failure, void>> call(String userId) async {
    final addressesResult = await addressRepository.getAddressesByUser(userId);
    addressesResult.fold(
      (_) {},
      (addresses) async {
        for (var addr in addresses) {
          await addressRepository.deleteAddress(addr.id);
        }
      },
    );
    return userRepository.deleteUser(userId);
  }
}
