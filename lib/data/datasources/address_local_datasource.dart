import 'package:hive/hive.dart';
import '../models/address_model.dart';

abstract class AddressLocalDataSource {
  Future<List<AddressModel>> getAddressesByUser(String userId);

  Future<void> saveAddress(AddressModel address);

  Future<void> updateAddress(AddressModel address);

  Future<void> deleteAddress(String id);

  Future<void> setPrimaryAddress(String id, String userId);
}

class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  final Box<AddressModel> addressBox;

  AddressLocalDataSourceImpl(this.addressBox);

  @override
  Future<List<AddressModel>> getAddressesByUser(String userId) async {
    return addressBox.values.where((a) => a.userId == userId).toList();
  }

  @override
  Future<void> saveAddress(AddressModel address) async {
    await addressBox.put(address.id, address);
  }

  @override
  Future<void> updateAddress(AddressModel address) async {
    await addressBox.put(address.id, address);
  }

  @override
  Future<void> deleteAddress(String id) async {
    await addressBox.delete(id);
  }

  @override
  Future<void> setPrimaryAddress(String id, String userId) async {
    final addresses = await getAddressesByUser(userId);

    for (var a in addresses) {
      await addressBox.put(
        a.id,
        AddressModel(
          id: a.id,
          userId: a.userId,
          street: a.street,
          neighborhood: a.neighborhood,
          city: a.city,
          state: a.state,
          postalCode: a.postalCode,
          label: a.label,
          isPrimary: a.id == id,
        ),
      );
    }
  }
}
