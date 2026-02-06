import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDialogs {
  static Future<void> confirmDelete({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              context.pop();
              onConfirm();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
