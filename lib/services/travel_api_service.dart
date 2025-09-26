import '../config/api_config.dart';
import '../models/api_models.dart';
import 'api_service.dart';

class TravelApiService {
  // 여행 정산 관리
  static Future<ApiResponse<List<TravelSettlementApi>>> getTravelSettlements() async {
    final response = await ApiService.get<List<dynamic>>(
      ApiConfig.travelSettlements,
    );
    
    if (response.isSuccess && response.data != null) {
      final settlements = (response.data as List<dynamic>)
          .map((s) => TravelSettlementApi.fromJson(s as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(settlements, message: response.message);
    } else {
      return ApiResponse.error(
        response.errorCode ?? 'UNKNOWN_ERROR',
        response.errorMessage ?? '여행 정산 목록을 불러올 수 없습니다',
      );
    }
  }

  static Future<ApiResponse<TravelSettlementApi>> getTravelSettlement(String id) async {
    return await ApiService.get<TravelSettlementApi>(
      '${ApiConfig.travelSettlements}/$id',
      fromJson: TravelSettlementApi.fromJson,
    );
  }

  static Future<ApiResponse<TravelSettlementApi>> createTravelSettlement({
    required String title,
    required double totalAmount,
    GameStatusApi status = GameStatusApi.inProgress,
  }) async {
    return await ApiService.post<TravelSettlementApi>(
      ApiConfig.travelSettlements,
      data: {
        'title': title,
        'totalAmount': totalAmount,
        'status': status.value,
      },
      fromJson: TravelSettlementApi.fromJson,
    );
  }

  static Future<ApiResponse<TravelSettlementApi>> updateTravelSettlement(
    String id, {
    required String title,
    required double totalAmount,
    required GameStatusApi status,
  }) async {
    return await ApiService.put<TravelSettlementApi>(
      '${ApiConfig.travelSettlements}/$id',
      data: {
        'title': title,
        'totalAmount': totalAmount,
        'status': status.value,
      },
      fromJson: TravelSettlementApi.fromJson,
    );
  }

  static Future<ApiResponse<void>> deleteTravelSettlement(String id) async {
    return await ApiService.delete<void>('${ApiConfig.travelSettlements}/$id');
  }

  // 여행 지출 관리
  static Future<ApiResponse<List<TravelExpenseApi>>> getTravelExpenses(String settlementId) async {
    final response = await ApiService.get<List<dynamic>>(
      ApiConfig.travelExpenses(settlementId),
    );
    
    if (response.isSuccess && response.data != null) {
      final expenses = (response.data as List<dynamic>)
          .map((e) => TravelExpenseApi.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(expenses, message: response.message);
    } else {
      return ApiResponse.error(
        response.errorCode ?? 'UNKNOWN_ERROR',
        response.errorMessage ?? '여행 지출 목록을 불러올 수 없습니다',
      );
    }
  }

  static Future<ApiResponse<TravelExpenseApi>> createTravelExpense(
    String settlementId, {
    required String participantId,
    required double amount,
    String? description,
  }) async {
    return await ApiService.post<TravelExpenseApi>(
      ApiConfig.travelExpenses(settlementId),
      data: {
        'participantId': participantId,
        'amount': amount,
        'description': description,
      },
      fromJson: TravelExpenseApi.fromJson,
    );
  }

  static Future<ApiResponse<TravelExpenseApi>> updateTravelExpense(
    String settlementId,
    String expenseId, {
    required String participantId,
    required double amount,
    String? description,
  }) async {
    return await ApiService.put<TravelExpenseApi>(
      ApiConfig.travelExpense(settlementId, expenseId),
      data: {
        'participantId': participantId,
        'amount': amount,
        'description': description,
      },
      fromJson: TravelExpenseApi.fromJson,
    );
  }

  static Future<ApiResponse<void>> deleteTravelExpense(
    String settlementId,
    String expenseId,
  ) async {
    return await ApiService.delete<void>(
      ApiConfig.travelExpense(settlementId, expenseId),
    );
  }
}
