import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_management_app/data/datasources/address_local_datasource.dart';
import 'package:user_management_app/data/datasources/user_local_datasource.dart';
import 'package:user_management_app/data/models/address_model.dart';
import 'package:user_management_app/data/models/user_model.dart';
import 'package:user_management_app/domain/repositories/address_repository.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';
import 'package:user_management_app/domain/usecases/users/delete_user_usecase.dart';
import 'package:user_management_app/domain/usecases/users/get_users_usecase.dart';
import 'package:user_management_app/presentation/blocs/address/address_bloc.dart';
import 'package:user_management_app/presentation/blocs/address_form/address_form_bloc.dart';
import 'package:user_management_app/presentation/blocs/user/user_bloc.dart';
import 'package:user_management_app/presentation/blocs/user_form/user_form_bloc.dart';

import 'package:user_management_app/core/di/injection.dart' as di;

class MockUserBox extends Mock implements Box<UserModel> {}

class MockAddressBox extends Mock implements Box<AddressModel> {}

void main() {
  late GetIt sl;
  late MockUserBox mockUserBox;
  late MockAddressBox mockAddressBox;

  setUp(() {
    sl = GetIt.instance;
    sl.reset();

    mockUserBox = MockUserBox();
    mockAddressBox = MockAddressBox();
  });

  test('All dependencies should be registered correctly', () async {
    await di.init(userBoxParam: mockUserBox, addressBoxParam: mockAddressBox);

    // Blocs
    expect(sl.isRegistered<UserBloc>(), true);
    expect(sl.isRegistered<UserFormBloc>(), true);

    // DataSources
    expect(sl.isRegistered<UserLocalDataSource>(), true);
    expect(sl.isRegistered<AddressLocalDataSource>(), true);

    // Repositories
    expect(sl.isRegistered<UserRepository>(), true);
    expect(sl.isRegistered<AddressRepository>(), true);

    // UseCases
    expect(sl.isRegistered<GetUsersUsecase>(), true);
    expect(sl.isRegistered<DeleteUserUsecase>(), true);
  });

  test('UserBloc should be creatable and functional', () async {
    await di.init(userBoxParam: mockUserBox, addressBoxParam: mockAddressBox);
    final bloc = sl<UserBloc>();

    expect(bloc, isA<UserBloc>());
    expect(bloc.state, isA<UserState>());
  });

  test('UserFormBloc should receive a UserEntity parameter', () async {
    await di.init(userBoxParam: mockUserBox, addressBoxParam: mockAddressBox);
    final bloc = sl<UserFormBloc>(param1: null);

    expect(bloc, isA<UserFormBloc>());
  });

  test('AddressFormBloc should receive a UserEntity parameter', () async {
    await di.init(userBoxParam: mockUserBox, addressBoxParam: mockAddressBox);
    final bloc = sl<AddressFormBloc>();

    expect(bloc, isA<AddressFormBloc>());
  });

  test('AddressBloc should receive a UserEntity parameter', () async {
    await di.init(userBoxParam: mockUserBox, addressBoxParam: mockAddressBox);
    final bloc = sl<AddressBloc>();

    expect(bloc, isA<AddressBloc>());
  });

  test('Singleton instances should be the same', () async {
    await di.init(userBoxParam: mockUserBox, addressBoxParam: mockAddressBox);

    final repo1 = sl<UserRepository>();
    final repo2 = sl<UserRepository>();

    expect(identical(repo1, repo2), true);
  });
}
