part of 'user_form_bloc.dart';

abstract class UserFormEvent {}

class FirstNameChanged extends UserFormEvent {
  final String value;
  FirstNameChanged(this.value);
}

class LastNameChanged extends UserFormEvent {
  final String value;
  LastNameChanged(this.value);
}

class EmailChanged extends UserFormEvent {
  final String value;
  EmailChanged(this.value);
}

class PhoneChanged extends UserFormEvent {
  final String value;
  PhoneChanged(this.value);
}

class BirthDateChanged extends UserFormEvent {
  final DateTime value;
  BirthDateChanged(this.value);
}

class SubmitUserForm extends UserFormEvent {
  final String? userId;

  SubmitUserForm({this.userId});
}
