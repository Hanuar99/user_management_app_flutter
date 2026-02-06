import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/presentation/blocs/address/address_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/user_entity.dart';
import 'widgets/user_header.dart';
import 'widgets/user_info_card.dart';
import 'widgets/address_list_preview.dart';

class UserDetailPage extends StatelessWidget {
  final UserEntity user;

  const UserDetailPage({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AddressBloc>().add(LoadAddressesEvent(user.id));

    return _UserDetailView(user: user);
  }
}

class _UserDetailView extends StatelessWidget {
  final UserEntity user;
  const _UserDetailView({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserHeader(user: user),
            const SizedBox(height: AppSpacing.lg),
            UserInfoCard(user: user),
            const SizedBox(height: AppSpacing.lg),
            AddressListPreview(user: user),
          ],
        ),
      ),
    );
  }
}
