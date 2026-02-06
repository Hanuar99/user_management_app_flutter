import 'package:flutter/material.dart';
import 'package:user_management_app/core/theme/app_spacing.dart';
import 'package:user_management_app/domain/entities/address_entity.dart';

enum AddressCardMode { compact, full }

class AddressCard extends StatelessWidget {
  final AddressEntity address;
  final AddressCardMode mode;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetPrimary;

  const AddressCard({
    required this.address,
    this.mode = AddressCardMode.full,
    this.onEdit,
    this.onDelete,
    this.onSetPrimary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: address.isPrimary
              ? colors.primary.withValues(alpha: 0.5)
              : Colors.grey.shade200,
          width: address.isPrimary ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: mode == AddressCardMode.compact ? null : onSetPrimary,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderSection(address: address),
                const SizedBox(height: AppSpacing.sm),
                _AddressInfoSection(address: address),
                if (mode == AddressCardMode.full) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _ActionsSection(onEdit: onEdit!, onDelete: onDelete!),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final AddressEntity address;
  const _HeaderSection({required this.address});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_getIconByLabel(address.label), color: colors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(address.label,
              style:
                  textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        ),
        if (address.isPrimary)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Principal',
              style: textTheme.bodySmall?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
      ],
    );
  }

  IconData _getIconByLabel(String label) {
    switch (label.toLowerCase()) {
      case 'casa':
        return Icons.home_outlined;
      case 'trabajo':
        return Icons.work_outline;
      default:
        return Icons.location_on_outlined;
    }
  }
}

class _AddressInfoSection extends StatelessWidget {
  final AddressEntity address;
  const _AddressInfoSection({required this.address});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address.street, style: textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xs),
        Text('${address.city}, ${address.state}', style: textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xs),
        Text('CP: ${address.postalCode}', style: textTheme.bodySmall),
      ],
    );
  }
}

class _ActionsSection extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ActionsSection({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Editar')),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: onDelete,
          icon: Icon(Icons.delete_outline, color: colors.error),
          label: Text('Eliminar', style: TextStyle(color: colors.error)),
        ),
      ],
    );
  }
}
