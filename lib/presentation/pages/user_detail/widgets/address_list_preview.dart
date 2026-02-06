import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_management_app/core/routes/app_routes.dart';
import 'package:user_management_app/presentation/blocs/address/address_bloc.dart';
import 'package:user_management_app/presentation/pages/address/widgets/address_card.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../domain/entities/user_entity.dart';

class AddressListPreview extends StatelessWidget {
  final UserEntity user;

  const AddressListPreview({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: AppStyles.cardDecoration,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Direcciones',
                    style: theme.textTheme.titleMedium,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      context.push(
                        AppRoutes.addressManagement,
                        extra: user,
                      );
                    },
                    icon: const Icon(Icons.edit_location_alt),
                    label: const Text('Gestionar'),
                  )
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (state is AddressLoading) ...[
                Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (state is AddressLoaded && state.addresses.isEmpty) ...[
                Text(
                  'Este usuario no tiene direcciones registradas',
                  style: theme.textTheme.bodySmall,
                )
              ] else if (state is AddressLoaded) ...[
                Column(
                  children: state.addresses.take(2).map((address) {
                    return AddressCard(
                      address: address,
                      mode: AddressCardMode.compact,
                      onSetPrimary: () {
                        context.read<AddressBloc>().add(SetPrimaryAddressEvent(
                              userId: user.id,
                              id: address.id,
                            ));
                      },
                    );
                  }).toList(),
                )
              ]
            ],
          ),
        );
      },
    );
  }
}
