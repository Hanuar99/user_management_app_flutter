import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:user_management_app/data/datasources/address_local_datasource.dart';
import 'package:user_management_app/data/models/address_model.dart';
import 'package:user_management_app/data/models/user_model.dart';
import 'package:user_management_app/data/repositories/address_repository_impl.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/domain/repositories/address_repository.dart';
import 'package:user_management_app/domain/usecases/addresses/delete_address_usecase.dart';
import 'package:user_management_app/domain/usecases/addresses/get_address_by_user_usecase.dart';
import 'package:user_management_app/domain/usecases/addresses/save_address_usecase.dart';
import 'package:user_management_app/domain/usecases/addresses/set_primary_address_usecase.dart';
import 'package:user_management_app/domain/usecases/addresses/update_address_usecase.dart';
import 'package:user_management_app/domain/usecases/users/delete_user_usecase.dart';
import 'package:user_management_app/domain/usecases/users/get_user_by_id_usecase.dart';
import 'package:user_management_app/domain/usecases/users/save_user_usecase.dart';
import 'package:user_management_app/domain/usecases/users/update_user_usecase.dart';
import 'package:user_management_app/presentation/blocs/address/address_bloc.dart';
import 'package:user_management_app/presentation/blocs/address_form/address_form_bloc.dart';
import 'package:user_management_app/presentation/blocs/user/user_bloc.dart';
import 'package:user_management_app/presentation/blocs/user_form/user_form_bloc.dart';

import '../../data/datasources/user_local_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/users/get_users_usecase.dart';

final sl = GetIt.instance;

Future<void> init(
    {Box<UserModel>? userBoxParam, Box<AddressModel>? addressBoxParam}) async {
  final userBox = userBoxParam ?? Hive.box<UserModel>('users');
  final addressBox = addressBoxParam ?? Hive.box<AddressModel>('addresses');

  // Bloc
  sl.registerFactory(
    () => UserBloc(
      getUsersUsecase: sl(),
      deleteUserUsecase: sl(),
    ),
  );

  sl.registerFactory(
    () => AddressBloc(
      getAddressesByUser: sl(),
      deleteAddress: sl(),
      setPrimaryAddress: sl(),
    ),
  );

  sl.registerFactoryParam<AddressFormBloc, AddressEntity?, void>(
    (address, _) => AddressFormBloc(
      saveAddress: sl(),
      updateAddress: sl(),
      address: address,
    ),
  );

  sl.registerFactoryParam<UserFormBloc, UserEntity?, void>(
    (user, _) => UserFormBloc(
      saveUser: sl(),
      updateUser: sl(),
      user: user,
    ),
  );

  // DataSources
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(userBox),
  );

  sl.registerLazySingleton<AddressLocalDataSource>(
    () => AddressLocalDataSourceImpl(addressBox),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetUsersUsecase(sl()));
  sl.registerLazySingleton(() => GetUserByIdUsecase(sl()));
  sl.registerLazySingleton(() => DeleteUserUsecase(sl(), sl()));
  sl.registerLazySingleton(() => SaveUserUsecase(sl()));
  sl.registerLazySingleton(() => UpdateUserUsecase(sl()));

  sl.registerLazySingleton(() => GetAddressByUserUseCase(sl()));
  sl.registerLazySingleton(() => SaveAddressUsecase(sl()));
  sl.registerLazySingleton(() => UpdateAddressUsecase(sl()));
  sl.registerLazySingleton(() => DeleteAddressUsecase(sl()));
  sl.registerLazySingleton(() => SetPrimaryAddressUsecase(sl()));
}
