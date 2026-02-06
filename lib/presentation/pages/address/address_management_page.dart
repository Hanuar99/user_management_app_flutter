import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_management_app/core/routes/app_routes.dart';
import 'package:user_management_app/domain/entities/user_entity.dart';
import 'package:user_management_app/presentation/pages/address/widgets/address_list.dart';

class AddressManagementPage extends StatelessWidget {
  final UserEntity user;

  const AddressManagementPage({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direcciones'),
      ),
      body: AddressList(userId: user.id),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(
            AppRoutes.addressForm,
            extra: {'userId': user.id, 'address': null},
          );
        },
        label: const Text('Agregar dirección'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
