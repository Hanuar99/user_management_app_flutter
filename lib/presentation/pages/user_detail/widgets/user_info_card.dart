import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../domain/entities/user_entity.dart';
import 'package:intl/intl.dart';

class UserInfoCard extends StatelessWidget {
  final UserEntity user;

  const UserInfoCard({required this.user, super.key});

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información personal',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(
            label: 'Nombre completo',
            value: '${user.firstName} ${user.lastName}',
          ),
          _InfoRow(
            label: 'Correo electrónico',
            value: user.email,
          ),
          _InfoRow(
            label: 'Teléfono',
            value: user.phone,
          ),
          _InfoRow(
            label: 'Fecha de nacimiento',
            value: _formatDate(user.birthDate),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
