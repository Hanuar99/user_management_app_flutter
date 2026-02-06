import 'package:hive/hive.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel?> getUserById(String id);
  Future<void> saveUser(UserModel user);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String id);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box<UserModel> userBox;

  UserLocalDataSourceImpl(this.userBox);

  @override
  Future<List<UserModel>> getUsers() async {
    return userBox.values.toList();
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    return userBox.get(id);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await userBox.put(user.id, user);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await userBox.put(user.id, user);
  }

  @override
  Future<void> deleteUser(String id) async {
    await userBox.delete(id);
  }
}
