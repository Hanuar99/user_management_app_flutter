import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/user_model.dart';
import '../../data/models/address_model.dart';

class HiveConfig {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(AddressModelAdapter());

    await Hive.openBox<UserModel>('users');
    await Hive.openBox<AddressModel>('addresses');
  }
}
