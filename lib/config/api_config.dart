import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // API 기본 설정
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';
  static int get timeout => int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;
  
  // API 엔드포인트
  static const String participants = '/participants';
  static const String games = '/games';
  static const String travelSettlements = '/travel-settlements';
  
  // 게임 관련 엔드포인트
  static String gameParticipants(String gameId) => '/games/$gameId/participants';
  static String gameRounds(String gameId) => '/games/$gameId/rounds';
  static String gameRound(String gameId, String roundId) => '/games/$gameId/rounds/$roundId';
  static String gameSettlement(String gameId) => '/games/$gameId/settlement';
  static String gameSettlementCalculate(String gameId) => '/games/$gameId/settlement/calculate';
  
  // 라운드 관련 엔드포인트
  static String roundPayments(String roundId) => '/rounds/$roundId/payments';
  static String payment(String paymentId) => '/payments/$paymentId';
  
  // 여행 정산 관련 엔드포인트
  static String travelExpenses(String settlementId) => '/travel-settlements/$settlementId/expenses';
  static String travelExpense(String settlementId, String expenseId) => '/travel-settlements/$settlementId/expenses/$expenseId';
  
  // HTTP 헤더
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // 에러 코드
  static const String validationError = 'VALIDATION_ERROR';
  static const String notFoundError = 'NOT_FOUND';
  static const String serverError = 'SERVER_ERROR';
  static const String unauthorizedError = 'UNAUTHORIZED';
  static const String forbiddenError = 'FORBIDDEN';
}
