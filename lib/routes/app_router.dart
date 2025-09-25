import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/travel_settlement_screen.dart';
import '../screens/game_settlement_screen.dart';
import '../screens/settlement_result_screen.dart';
import '../screens/history_screen.dart';
import '../screens/profile_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String travelSettlement = '/travel-settlement';
  static const String gameSettlement = '/game-settlement';
  static const String settlementResult = '/settlement-result';
  static const String history = '/history';
  static const String profile = '/profile';
  
  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      // Home Route
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Travel Settlement Route
      GoRoute(
        path: travelSettlement,
        name: 'travel-settlement',
        builder: (context, state) => const TravelSettlementScreen(),
      ),
      
      // Game Settlement Route
      GoRoute(
        path: gameSettlement,
        name: 'game-settlement',
        builder: (context, state) => const GameSettlementScreen(),
      ),
      
      // Settlement Result Route
      GoRoute(
        path: '$settlementResult/:id',
        name: 'settlement-result',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SettlementResultScreen(settlementId: id);
        },
      ),
      
      // History Route
      GoRoute(
        path: history,
        name: 'history',
        builder: (context, state) => const HistoryScreen(),
      ),
      
      // Profile Route
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    
    // Error Page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              '페이지를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '요청하신 페이지가 존재하지 않습니다.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    ),
  );
}
