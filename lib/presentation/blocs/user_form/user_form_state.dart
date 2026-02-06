part of 'user_form_bloc.dart';

class UserFormState extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final DateTime? birthDate;

  final String? firstNameError;
  final String? lastNameError;
  final String? emailError;
  final String? phoneError;
  final String? birthDateError;

  final bool isValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const UserFormState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.birthDate,
    this.firstNameError,
    this.lastNameError,
    this.emailError,
    this.phoneError,
    this.birthDateError,
    this.isValid = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  UserFormState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    DateTime? birthDate,
    String? firstNameError,
    String? lastNameError,
    String? emailError,
    String? phoneError,
    String? birthDateError,
    bool? isValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return UserFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      firstNameError: firstNameError,
      lastNameError: lastNameError,
      emailError: emailError,
      phoneError: phoneError,
      birthDateError: birthDateError,
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phone,
        birthDate,
        firstNameError,
        lastNameError,
        emailError,
        phoneError,
        birthDateError,
        isValid,
        isSubmitting,
        isSuccess,
        errorMessage,
      ];
}
