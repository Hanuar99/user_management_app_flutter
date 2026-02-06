import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AppGradient {
  static LinearGradient primary() {
    return const LinearGradient(
      colors: [
        AppColors.primary,
        AppColors.secondary,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
