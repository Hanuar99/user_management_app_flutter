import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_management_app/core/errors/failures.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/domain/usecases/users/save_user_usecase.dart';
import 'package:user_management_app/domain/usecases/users/update_user_usecase.dart';
import 'package:user_management_app/presentation/blocs/user_form/user_form_bloc.dart';

class MockSaveUserUsecase extends Mock implements SaveUserUsecase {}

class MockUpdateUserUsecase extends Mock implements UpdateUserUsecase {}

void main() {
  late UserFormBloc bloc;
  late MockSaveUserUsecase mockSaveUser;
  late MockUpdateUserUsecase mockUpdateUser;

  final tUser = UserEntity(
    id: '1',
    firstName: 'Hanuar',
    lastName: 'Rubio',
    email: 'hanuar@test.com',
    phone: '3001234567',
    birthDate: DateTime(1999, 4, 19),
  );

  setUp(() {
    mockSaveUser = MockSaveUserUsecase();
    mockUpdateUser = MockUpdateUserUsecase();

    bloc = UserFormBloc(
        saveUser: mockSaveUser, updateUser: mockUpdateUser, user: tUser);

    registerFallbackValue(tUser);
  });

  group('Field validation', () {
    blocTest<UserFormBloc, UserFormState>(
      'should update firstName and validate correctly',
      build: () => bloc,
      act: (bloc) => bloc.add(FirstNameChanged('')),
      expect: () => [
        isA<UserFormState>()
            .having((s) => s.firstName, 'firstName', '')
            .having((s) => s.firstNameError, 'error', isNotNull)
            .having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<UserFormBloc, UserFormState>(
      'should update lastName and validate correctly',
      build: () => bloc,
      act: (bloc) => bloc.add(LastNameChanged('Rubio')),
      expect: () => [
        isA<UserFormState>()
            .having((s) => s.lastName, 'lastName', 'Rubio')
            .having((s) => s.lastNameError, 'error', isNull),
      ],
    );

    blocTest<UserFormBloc, UserFormState>(
      'should update email and validate correctly',
      build: () => bloc,
      act: (bloc) => bloc.add(EmailChanged('invalid-email')),
      expect: () => [
        isA<UserFormState>()
            .having((s) => s.email, 'email', 'invalid-email')
            .having((s) => s.emailError, 'error', isNotNull)
            .having((s) => s.isValid, 'isValid', false),
      ],
    );
    blocTest<UserFormBloc, UserFormState>(
      'should update phone and validate correctly',
      build: () => bloc,
      act: (bloc) => bloc.add(PhoneChanged('invalid-phone')),
      expect: () => [
        isA<UserFormState>()
            .having((s) => s.phone, 'phone', 'invalid-phone')
            .having((s) => s.phoneError, 'error', isNotNull)
            .having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<UserFormBloc, UserFormState>(
      'should update birthDate and validate correctly',
      build: () => bloc,
      act: (bloc) => bloc.add(
          BirthDateChanged(DateTime(2025, 1, 1))), // fecha futura -> invalida
      expect: () => [
        isA<UserFormState>()
            .having((s) => s.birthDate, 'birthDate', DateTime(2025, 1, 1))
            .having((s) => s.birthDateError, 'error', isNotNull)
            .having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<UserFormBloc, UserFormState>(
      'should update birthDate with valid date',
      build: () => bloc,
      act: (bloc) => bloc.add(BirthDateChanged(DateTime(1999, 4, 19))),
      expect: () => [
        isA<UserFormState>()
            .having((s) => s.birthDate, 'birthDate', DateTime(1999, 4, 19))
            .having((s) => s.birthDateError, 'error', isNull)
            .having((s) => s.isValid, 'isValid', true),
      ],
    );
  });
  group('Submit UserForm', () {
    blocTest<UserFormBloc, UserFormState>(
      'should emit [isSubmitting true, isSuccess true] when saveUser succeeds',
      build: () {
        when(() => mockSaveUser(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) {
        bloc.add(SubmitUserForm());
      },
      seed: () => bloc.state.copyWith(
        firstName: 'Hanuar',
        lastName: 'Rubio',
        email: 'hanuar@test.com',
        phone: '3001234567',
        birthDate: DateTime(1999, 4, 19),
      ),
      expect: () => [
        isA<UserFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<UserFormState>()
            .having((s) => s.isSuccess, 'isSuccess', true)
            .having((s) => s.isSubmitting, 'isSubmitting', false),
      ],
      verify: (_) => verify(() => mockSaveUser(any())).called(1),
    );

    blocTest<UserFormBloc, UserFormState>(
      'should emit [isSubmitting true, errorMessage] when saveUser fails',
      build: () {
        when(() => mockSaveUser(any()))
            .thenAnswer((_) async => Left(CacheFailure("Save Error")));
        return UserFormBloc(
          saveUser: mockSaveUser,
          updateUser: mockUpdateUser,
          user: null,
        );
      },
      seed: () => UserFormState(
        firstName: 'Hanuar',
        lastName: 'Rubio',
        email: 'hanuar@test.com',
        phone: '3001234567',
        birthDate: DateTime(1999, 4, 19),
        isValid: true,
      ),
      act: (bloc) => bloc.add(SubmitUserForm()),
      expect: () => [
        isA<UserFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<UserFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having((s) => s.errorMessage, 'errorMessage', 'Save Error'),
      ],
      verify: (_) => verify(() => mockSaveUser(any())).called(1),
    );

    blocTest<UserFormBloc, UserFormState>(
      'should call updateUser if userId is provided',
      build: () {
        when(() => mockUpdateUser(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => bloc.state.copyWith(
        firstName: 'Hanuar',
        lastName: 'Rubio',
        email: 'hanuar@test.com',
        phone: '3001234567',
        birthDate: DateTime(1999, 4, 19),
        isValid: true,
      ),
      act: (bloc) => bloc.add(SubmitUserForm(userId: '1')),
      expect: () => [
        isA<UserFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<UserFormState>()
            .having((s) => s.isSuccess, 'isSuccess', true)
            .having((s) => s.isSubmitting, 'isSubmitting', false),
      ],
      verify: (_) => verify(() => mockUpdateUser(any())).called(1),
    );
  });

  group('Submit UserForm', () {
    blocTest<UserFormBloc, UserFormState>(
      'should emit [isSubmitting true, isSuccess true] when saveUser succeeds',
      build: () {
        when(() => mockSaveUser(any()))
            .thenAnswer((_) async => const Right(null));
        return UserFormBloc(
          saveUser: mockSaveUser,
          updateUser: mockUpdateUser,
          user:
              null, // si quieres que el bloc use datos vacíos y los pones en seed
        );
      },
      seed: () => UserFormState(
        firstName: 'Hanuar',
        lastName: 'Rubio',
        email: 'hanuar@test.com',
        phone: '3001234567',
        birthDate: DateTime(1999, 4, 19),
        isValid: true,
      ),
      act: (bloc) => bloc.add(SubmitUserForm()),
      expect: () => [
        isA<UserFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<UserFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having((s) => s.isSuccess, 'isSuccess', true),
      ],
      verify: (_) => verify(() => mockSaveUser(any())).called(1),
    );

    blocTest<UserFormBloc, UserFormState>(
      'should emit [isSubmitting true, errorMessage] when saveUser fails',
      build: () {
        when(() => mockSaveUser(any()))
            .thenAnswer((_) async => Left(CacheFailure("Save Error")));
        return bloc;
      },
      // Inicializa el estado antes del evento con seed
      seed: () => bloc.state.copyWith(
        firstName: 'Hanuar',
        lastName: 'Rubio',
        email: 'hanuar@test.com',
        phone: '3001234567',
        birthDate: DateTime(1999, 4, 19),
        isValid: true,
      ),
      act: (bloc) => bloc.add(SubmitUserForm()),
      expect: () => [
        isA<UserFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<UserFormState>()
            .having((s) => s.errorMessage, 'errorMessage', 'Save Error')
            .having((s) => s.isSubmitting, 'isSubmitting', false),
      ],
      verify: (_) => verify(() => mockSaveUser(any())).called(1),
    );

    blocTest<UserFormBloc, UserFormState>(
      'should call updateUser if userId is provided',
      build: () {
        when(() => mockUpdateUser(any()))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      // Estado inicial
      seed: () => bloc.state.copyWith(
        firstName: 'Hanuar',
        lastName: 'Rubio',
        email: 'hanuar@test.com',
        phone: '3001234567',
        birthDate: DateTime(1999, 4, 19),
        isValid: true,
      ),
      // Solo agregamos el evento
      act: (bloc) => bloc.add(SubmitUserForm(userId: '1')),
      expect: () => [
        isA<UserFormState>()
            .having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<UserFormState>()
            .having((s) => s.isSuccess, 'isSuccess', true)
            .having((s) => s.isSubmitting, 'isSubmitting', false),
      ],
      verify: (_) => verify(() => mockUpdateUser(any())).called(1),
    );
  });
}
