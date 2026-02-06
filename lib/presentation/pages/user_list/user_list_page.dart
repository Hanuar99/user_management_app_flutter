import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_routes.dart';

import '../../blocs/user/user_bloc.dart';
import 'widgets/user_list_widget.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserBloc>()..add(LoadUsersEvent()),
      child: const UserListView(),
    );
  }
}

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Usuarios')),
      body: const UserListWidget(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await context.push<bool>(AppRoutes.userForm);
          if (result == true) {
            userBloc.add(LoadUsersEvent());
          }
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo usuario'),
      ),
    );
  }
}
