import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_management_app/presentation/blocs/user/user_bloc.dart';
import 'package:user_management_app/presentation/pages/user_list/widgets/action_icon.dart';
import 'package:user_management_app/presentation/widgets/common/app_dialogs.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_styles.dart';

import '../../../../domain/entities/user_entity.dart';

class UserTile extends StatelessWidget {
  final UserEntity user;

  const UserTile({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Container(
        decoration: AppStyles.cardDecoration,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              user.firstName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            '${user.firstName} ${user.lastName}',
            style: theme.textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            user.email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ActionIcon(
                icon: Icons.edit,
                tooltip: 'Editar',
                color: theme.colorScheme.primary,
                onTap: () async {
                  final result =
                      await context.push<bool>(AppRoutes.userForm, extra: user);
                  if (result == true) {
                    userBloc.add(LoadUsersEvent());
                  }
                },
              ),
              ActionIcon(
                  icon: Icons.delete_outline,
                  tooltip: 'Eliminar',
                  color: Colors.red,
                  onTap: () {
                    AppDialogs.confirmDelete(
                      context: context,
                      title: 'Eliminar usuario',
                      message:
                          '¿Deseas eliminar a ${user.firstName} ${user.lastName}? '
                          'Esta acción no se puede deshacer.',
                      onConfirm: () {
                        context.read<UserBloc>().add(DeleteUserEvent(user.id));
                      },
                    );
                  }),
            ],
          ),
          onTap: () {
            context.push(AppRoutes.userDetail, extra: user);
          },
        ),
      ),
    );
  }
}
