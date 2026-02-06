import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/core/validators/user_validators.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/domain/usecases/users/save_user_usecase.dart';
import 'package:user_management_app/domain/usecases/users/update_user_usecase.dart';
import 'package:uuid/uuid.dart';

part 'user_form_event.dart';
part 'user_form_state.dart';

class UserFormBloc extends Bloc<UserFormEvent, UserFormState> {
  final SaveUserUsecase saveUser;
  final UpdateUserUsecase updateUser;

  UserFormBloc({
    required this.saveUser,
    required this.updateUser,
    UserEntity? user,
  }) : super(
          UserFormState(
            firstName: user?.firstName ?? '',
            lastName: user?.lastName ?? '',
            email: user?.email ?? '',
            phone: user?.phone ?? '',
            birthDate: user?.birthDate,
            isValid: user != null &&
                UserValidators.validateName(user.firstName) == null &&
                UserValidators.validateLastName(user.lastName) == null &&
                UserValidators.validateEmail(user.email) == null &&
                UserValidators.validatePhone(user.phone) == null &&
                UserValidators.validateBirthDate(user.birthDate) == null,
          ),
        ) {
    on<FirstNameChanged>(_onValidate);
    on<LastNameChanged>(_onValidate);
    on<EmailChanged>(_onValidate);
    on<PhoneChanged>(_onValidate);
    on<BirthDateChanged>(_onValidate);

    on<SubmitUserForm>(_onSubmit);
  }
  void _onValidate(
    UserFormEvent event,
    Emitter<UserFormState> emit,
  ) {
    var newState = _mapEventToState(event, state);

    String? firstNameError = newState.firstNameError;
    String? lastNameError = newState.lastNameError;
    String? emailError = newState.emailError;
    String? phoneError = newState.phoneError;
    String? birthDateError = newState.birthDateError;

    if (event is FirstNameChanged) {
      firstNameError = UserValidators.validateName(newState.firstName);
    }

    if (event is LastNameChanged) {
      lastNameError = UserValidators.validateLastName(newState.lastName);
    }

    if (event is EmailChanged) {
      emailError = UserValidators.validateEmail(newState.email);
    }

    if (event is PhoneChanged) {
      phoneError = UserValidators.validatePhone(newState.phone);
    }

    if (event is BirthDateChanged) {
      birthDateError = UserValidators.validateBirthDate(newState.birthDate);
    }

    final isValid = [
      UserValidators.validateName(newState.firstName),
      UserValidators.validateLastName(newState.lastName),
      UserValidators.validateEmail(newState.email),
      UserValidators.validatePhone(newState.phone),
      UserValidators.validateBirthDate(newState.birthDate),
    ].every((e) => e == null);

    emit(
      newState.copyWith(
        firstNameError: firstNameError,
        lastNameError: lastNameError,
        emailError: emailError,
        phoneError: phoneError,
        birthDateError: birthDateError,
        isValid: isValid,
      ),
    );
  }

  UserFormState _mapEventToState(UserFormEvent event, UserFormState state) {
    if (event is FirstNameChanged) {
      return state.copyWith(firstName: event.value);
    }
    if (event is LastNameChanged) {
      return state.copyWith(lastName: event.value);
    }
    if (event is EmailChanged) {
      return state.copyWith(email: event.value);
    }
    if (event is PhoneChanged) {
      return state.copyWith(phone: event.value);
    }
    if (event is BirthDateChanged) {
      return state.copyWith(birthDate: event.value);
    }

    return state;
  }

  Future<void> _onSubmit(
    SubmitUserForm event,
    Emitter<UserFormState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    final user = UserEntity(
      id: event.userId ?? const Uuid().v4(),
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      phone: state.phone,
      birthDate: state.birthDate!,
    );

    final result =
        event.userId == null ? await saveUser(user) : await updateUser(user);

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        isSubmitting: false,
        isSuccess: true,
      )),
    );
  }
}
