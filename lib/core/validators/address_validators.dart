class AddressValidators {
  static String? validateStreet(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La calle es obligatoria';
    }

    if (value.length < 3) {
      return 'Debe tener al menos 3 caracteres';
    }

    return null;
  }

  static String? validateNeighborhood(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La colonia es obligatoria';
    }

    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La ciudad es obligatoria';
    }

    return null;
  }

  static String? validateState(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El estado es obligatorio';
    }

    return null;
  }

  static String? validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El código postal es obligatorio';
    }

    if (value.length < 4) {
      return 'Código postal inválido';
    }

    return null;
  }
}
