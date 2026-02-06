import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/presentation/widgets/common/app_snackbar.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../blocs/user/user_bloc.dart';
import 'user_tile.dart';

class UserListWidget extends StatefulWidget {
  const UserListWidget({super.key});

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Buscar usuario...',
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Expanded(
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserActionFailure) {
                AppSnackbar.showError(context, message: state.message);
              }
              if (state is UserActionSuccess) {
                AppSnackbar.showSuccess(context,
                    message: 'Eliminado con éxito');
              }
            },
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<UserBloc>().add(LoadUsersEvent());
                },
                child: _buildContent(state),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContent(UserState state) {
    final search = _controller.text.toLowerCase();

    if (state is UserLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is UserError) {
      return _ErrorState(message: state.message);
    }

    if (state is UserLoaded) {
      final users = state.users.where((u) {
        final fullName = '${u.firstName} ${u.lastName}'.toLowerCase();

        return fullName.contains(search) ||
            u.email.toLowerCase().contains(search);
      }).toList();

      if (users.isEmpty) {
        return const _EmptyState();
      }

      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: users.length,
        itemBuilder: (_, index) {
          return UserTile(
            key: ValueKey(users[index].id),
            user: users[index],
          );
        },
      );
    }

    return const SizedBox();
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.people_outline,
          size: 80,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Sin usuarios',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Aún no hay usuarios registrados',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 70,
          color: Colors.red.shade300,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(message),
        const SizedBox(height: AppSpacing.md),
        ElevatedButton.icon(
          onPressed: () {
            context.read<UserBloc>().add(LoadUsersEvent());
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Reintentar'),
        )
      ],
    );
  }
}
