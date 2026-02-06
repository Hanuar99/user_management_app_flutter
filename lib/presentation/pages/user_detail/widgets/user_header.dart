import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../domain/entities/user_entity.dart';

class UserHeader extends StatelessWidget {
  final UserEntity user;

  const UserHeader({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Text(
            user.firstName.substring(0, 1).toUpperCase(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.firstName} ${user.lastName}',
                key: const Key('user_full_name'),
                style: theme.textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        )
      ],
    );
  }
}
