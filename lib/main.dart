import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const JungsanApp());
}

class JungsanApp extends StatelessWidget {
  const JungsanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '정산',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}