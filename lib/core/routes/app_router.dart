import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_management_app/core/di/injection.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/presentation/blocs/address/address_bloc.dart';
import 'package:user_management_app/presentation/pages/address/address_form_page.dart';
import 'package:user_management_app/presentation/pages/address/address_management_page.dart';
import 'package:user_management_app/presentation/pages/user_detail/user_detail_page.dart';
import 'package:user_management_app/presentation/pages/user_form/user_form_page.dart';
import 'package:user_management_app/presentation/pages/user_list/user_list_page.dart';

import 'app_routes.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.users,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (_) => sl<AddressBloc>(),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.users,
            builder: (_, __) => const UserListPage(),
          ),
          GoRoute(
            path: AppRoutes.userDetail,
            builder: (_, state) => UserDetailPage(
              user: state.extra as UserEntity,
            ),
          ),
          GoRoute(
            path: AppRoutes.addressManagement,
            builder: (_, state) => AddressManagementPage(
              user: state.extra as UserEntity,
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.userForm,
        builder: (_, state) => UserFormPage(
          user: state.extra as UserEntity?,
        ),
      ),
      GoRoute(
        path: AppRoutes.addressForm,
        builder: (_, state) {
          final data = state.extra as Map;
          return AddressFormPage(
            userId: data['userId'],
            address: data['address'],
          );
        },
      ),
    ],
  );
}
