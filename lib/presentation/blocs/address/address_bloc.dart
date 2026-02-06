import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/domain/usecases/addresses/delete_address_usecase.dart';
import 'package:user_management_app/domain/usecases/addresses/get_address_by_user_usecase.dart';
import 'package:user_management_app/domain/usecases/addresses/set_primary_address_usecase.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddressByUserUseCase getAddressesByUser;
  final DeleteAddressUsecase deleteAddress;
  final SetPrimaryAddressUsecase setPrimaryAddress;

  AddressBloc({
    required this.getAddressesByUser,
    required this.deleteAddress,
    required this.setPrimaryAddress,
  }) : super(AddressInitial()) {
    on<LoadAddressesEvent>(_onLoad);
    on<DeleteAddressEvent>(_onDelete);
    on<SetPrimaryAddressEvent>(_onSetPrimary);
  }

  Future<void> _onLoad(
    LoadAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());

    final result = await getAddressesByUser(event.userId);

    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (addresses) => emit(AddressLoaded(addresses)),
    );
  }

  Future<void> _onDelete(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());

    final result = await deleteAddress(event.id);

    result.fold(
      (failure) => emit(AddressActionFailure(failure.message)),
      (_) => emit(AddressActionSuccess()),
    );
    add(LoadAddressesEvent(event.userId));
  }

  Future<void> _onSetPrimary(
    SetPrimaryAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    final result = await setPrimaryAddress(
        SetPrimaryAddressParams(id: event.id, userId: event.userId));

    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => add(LoadAddressesEvent(event.userId)),
    );
  }
}
