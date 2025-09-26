import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'routes/app_router.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 환경변수 로드
  await dotenv.load(fileName: "env/.env.local");
  
  // API 서비스 초기화
  ApiService.initialize();
  
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