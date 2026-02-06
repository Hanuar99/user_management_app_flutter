import 'package:flutter/material.dart';
import 'package:user_management_app/core/hive/hive_config.dart';
import 'package:user_management_app/core/routes/app_router.dart';
import 'package:user_management_app/core/theme/app_theme.dart';

import 'core/di/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveConfig.init();
  await di.init();

  runApp(const UserManagementApp());
}

class UserManagementApp extends StatelessWidget {
  const UserManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'User Management',
      theme: AppTheme.theme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
