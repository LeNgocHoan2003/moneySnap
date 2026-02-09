import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MoneySnap',
      theme: ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary)),
      routerConfig: appRouter,
    );
  }
}
