class UserValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "El nombre es obligatorio";
    }

    if (value.trim().length < 2) {
      return "Mínimo 2 caracteres";
    }

    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "El apellido es obligatorio";
    }

    if (value.trim().length < 2) {
      return "Mínimo 2 caracteres";
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "El email es obligatorio";
    }

    final regex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    if (!regex.hasMatch(value.trim())) {
      return "Email inválido";
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "El teléfono es obligatorio";
    }

    final regex = RegExp(r'^\+?[0-9]{10,13}$');

    if (!regex.hasMatch(value.trim())) {
      return "Teléfono inválido";
    }

    return null;
  }

  static String? validateBirthDate(DateTime? birthDate) {
    if (birthDate == null) {
      return "La fecha de nacimiento es obligatoria";
    }

    final today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    if (age < 18) {
      return "Debe ser mayor de 18 años";
    }

    if (age > 100) {
      return "La edad máxima permitida es 100 años";
    }

    return null;
  }
}
