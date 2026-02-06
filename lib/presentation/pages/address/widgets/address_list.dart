import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_management_app/core/routes/app_routes.dart';
import 'package:user_management_app/core/theme/app_spacing.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';
import 'package:user_management_app/presentation/blocs/address/address_bloc.dart';
import 'package:user_management_app/presentation/pages/address/widgets/address_card.dart';
import 'package:user_management_app/presentation/widgets/common/app_dialogs.dart';
import 'package:user_management_app/presentation/widgets/common/app_snackbar.dart';
import 'package:user_management_app/presentation/widgets/common/error_widget.dart';

class AddressList extends StatelessWidget {
  final String userId;

  const AddressList({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state is AddressActionFailure) {
          AppSnackbar.showError(context, message: state.message);
        }

        if (state is AddressActionSuccess) {
          AppSnackbar.showSuccess(context,
              message: 'Direccion eliminada con éxito');
        }
      },
      builder: (context, state) {
        if (state is AddressLoading) {
          return _LoadingState();
        }

        if (state is AddressError) {
          return AppErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<AddressBloc>().add(LoadAddressesEvent(userId));
              });
        }

        if (state is AddressLoaded) {
          if (state.addresses.isEmpty) {
            return _EmptyState();
          }

          return _AddressListContent(
              addresses: state.addresses, userId: userId);
        }

        return const SizedBox();
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppSpacing.md),
          Text('Cargando direcciones...'),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Sin direcciones registradas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Agrega una dirección para este usuario',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressListContent extends StatelessWidget {
  final List<AddressEntity> addresses;
  final String userId;

  const _AddressListContent({
    required this.addresses,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: addresses.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, index) {
        final address = addresses[index];

        return AddressCard(
          address: address,
          mode: AddressCardMode.full,
          onEdit: () {
            context.push(
              AppRoutes.addressForm,
              extra: {'userId': userId, 'address': address},
            );
          },
          onDelete: () {
            AppDialogs.confirmDelete(
              context: context,
              title: 'Eliminar dirección',
              message: '¿Estás seguro de eliminar esta dirección?',
              onConfirm: () {
                context.read<AddressBloc>().add(
                      DeleteAddressEvent(
                        userId: userId,
                        id: address.id,
                      ),
                    );
              },
            );
          },
          onSetPrimary: () {
            context.read<AddressBloc>().add(
                  SetPrimaryAddressEvent(
                    userId: userId,
                    id: address.id,
                  ),
                );
          },
        );
      },
    );
  }
}
