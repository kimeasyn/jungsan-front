import '../config/api_config.dart';
import '../models/api_models.dart';
import 'api_service.dart';

class GameApiService {
  // 참가자 관리
  static Future<ApiResponse<List<ParticipantApi>>> getParticipants() async {
    final response = await ApiService.get<List<dynamic>>(
      ApiConfig.participants,
    );
    
    if (response.isSuccess && response.data != null) {
      final participants = (response.data as List<dynamic>)
          .map((p) => ParticipantApi.fromJson(p as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(participants, message: response.message);
    } else {
      return ApiResponse.error(
        response.errorCode ?? 'UNKNOWN_ERROR',
        response.errorMessage ?? '참가자 목록을 불러올 수 없습니다',
      );
    }
  }

  static Future<ApiResponse<ParticipantApi>> getParticipant(String id) async {
    return await ApiService.get<ParticipantApi>(
      '${ApiConfig.participants}/$id',
      fromJson: ParticipantApi.fromJson,
    );
  }

  static Future<ApiResponse<ParticipantApi>> createParticipant({
    required String name,
    String? avatar,
  }) async {
    // 필수 필드 검증
    if (name.trim().isEmpty) {
      return ApiResponse.error(
        'VALIDATION_ERROR',
        '참가자 이름은 필수입니다.',
      );
    }

    // 데이터 정리
    final cleanName = name.trim();
    final cleanAvatar = avatar?.trim().isEmpty == true ? null : avatar?.trim();

    return await ApiService.post<ParticipantApi>(
      ApiConfig.participants,
      data: {
        'name': cleanName,
        'avatar': cleanAvatar,
      },
      fromJson: ParticipantApi.fromJson,
    );
  }

  static Future<ApiResponse<ParticipantApi>> updateParticipant(
    String id, {
    required String name,
    String? avatar,
    required bool isActive,
  }) async {
    return await ApiService.put<ParticipantApi>(
      '${ApiConfig.participants}/$id',
      data: {
        'name': name,
        'avatar': avatar,
        'isActive': isActive,
      },
      fromJson: ParticipantApi.fromJson,
    );
  }

  static Future<ApiResponse<void>> deleteParticipant(String id) async {
    return await ApiService.delete<void>('${ApiConfig.participants}/$id');
  }

  // 게임 관리
  static Future<ApiResponse<List<GameApi>>> getGames({GameStatusApi? status}) async {
    final queryParams = status != null ? {'status': status.value} : null;
    final response = await ApiService.get<List<dynamic>>(
      ApiConfig.games,
      queryParameters: queryParams,
    );
    
    if (response.isSuccess && response.data != null) {
      final games = (response.data as List<dynamic>)
          .map((g) => GameApi.fromJson(g as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(games, message: response.message);
    } else {
      return ApiResponse.error(
        response.errorCode ?? 'UNKNOWN_ERROR',
        response.errorMessage ?? '게임 목록을 불러올 수 없습니다',
      );
    }
  }

  static Future<ApiResponse<GameApi>> getGame(String id) async {
    return await ApiService.get<GameApi>(
      '${ApiConfig.games}/$id',
      fromJson: GameApi.fromJson,
    );
  }

  static Future<ApiResponse<GameApi>> createGame({
    required String title,
    GameStatusApi status = GameStatusApi.inProgress,
  }) async {
    // 필수 필드 검증
    if (title.trim().isEmpty) {
      return ApiResponse.error(
        'VALIDATION_ERROR',
        '게임 제목은 필수입니다.',
      );
    }

    // 데이터 정리
    final cleanTitle = title.trim();

    return await ApiService.post<GameApi>(
      ApiConfig.games,
      data: {
        'title': cleanTitle,
        'status': status.value,
      },
      fromJson: GameApi.fromJson,
    );
  }

  static Future<ApiResponse<GameApi>> updateGame(
    String id, {
    required String title,
    required GameStatusApi status,
  }) async {
    return await ApiService.put<GameApi>(
      '${ApiConfig.games}/$id',
      data: {
        'title': title,
        'status': status.value,
      },
      fromJson: GameApi.fromJson,
    );
  }

  static Future<ApiResponse<void>> deleteGame(String id) async {
    return await ApiService.delete<void>('${ApiConfig.games}/$id');
  }

  // 게임 참가자 관리
  static Future<ApiResponse<void>> addParticipantToGame(
    String gameId,
    String participantId,
  ) async {
    return await ApiService.post<void>(
      ApiConfig.gameParticipants(gameId),
      data: {'participantId': participantId},
    );
  }

  static Future<ApiResponse<void>> removeParticipantFromGame(
    String gameId,
    String participantId,
  ) async {
    return await ApiService.delete<void>(
      '${ApiConfig.gameParticipants(gameId)}/$participantId',
    );
  }

  // 게임 라운드 관리
  static Future<ApiResponse<List<GameRoundApi>>> getGameRounds(String gameId) async {
    final response = await ApiService.get<List<dynamic>>(
      ApiConfig.gameRounds(gameId),
    );
    
    if (response.isSuccess && response.data != null) {
      final rounds = (response.data as List<dynamic>)
          .map((r) => GameRoundApi.fromJson(r as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(rounds, message: response.message);
    } else {
      return ApiResponse.error(
        response.errorCode ?? 'UNKNOWN_ERROR',
        response.errorMessage ?? '라운드 목록을 불러올 수 없습니다',
      );
    }
  }

  static Future<ApiResponse<GameRoundApi>> createRound(
    String gameId, {
    required int roundNumber,
    required String winnerId,
  }) async {
    return await ApiService.post<GameRoundApi>(
      ApiConfig.gameRounds(gameId),
      data: {
        'roundNumber': roundNumber,
        'winnerId': winnerId,
      },
      fromJson: GameRoundApi.fromJson,
    );
  }

  static Future<ApiResponse<GameRoundApi>> getGameRound(
    String gameId,
    String roundId,
  ) async {
    return await ApiService.get<GameRoundApi>(
      ApiConfig.gameRound(gameId, roundId),
      fromJson: GameRoundApi.fromJson,
    );
  }

  static Future<ApiResponse<GameRoundApi>> createGameRound(
    String gameId, {
    required int roundNumber,
    required String winnerId,
  }) async {
    return await ApiService.post<GameRoundApi>(
      ApiConfig.gameRounds(gameId),
      data: {
        'roundNumber': roundNumber,
        'winnerId': winnerId,
      },
      fromJson: GameRoundApi.fromJson,
    );
  }

  static Future<ApiResponse<GameRoundApi>> updateGameRound(
    String gameId,
    String roundId, {
    required int roundNumber,
    required String winnerId,
  }) async {
    return await ApiService.put<GameRoundApi>(
      ApiConfig.gameRound(gameId, roundId),
      data: {
        'roundNumber': roundNumber,
        'winnerId': winnerId,
      },
      fromJson: GameRoundApi.fromJson,
    );
  }

  static Future<ApiResponse<void>> deleteGameRound(
    String gameId,
    String roundId,
  ) async {
    return await ApiService.delete<void>(
      ApiConfig.gameRound(gameId, roundId),
    );
  }

  // 지급 내역 관리
  static Future<ApiResponse<List<PaymentApi>>> getRoundPayments(String roundId) async {
    final response = await ApiService.get<List<dynamic>>(
      ApiConfig.roundPayments(roundId),
    );
    
    if (response.isSuccess && response.data != null) {
      final payments = (response.data as List<dynamic>)
          .map((p) => PaymentApi.fromJson(p as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(payments, message: response.message);
    } else {
      return ApiResponse.error(
        response.errorCode ?? 'UNKNOWN_ERROR',
        response.errorMessage ?? '지급 내역을 불러올 수 없습니다',
      );
    }
  }

  static Future<ApiResponse<PaymentApi>> createPayment(
    String roundId, {
    required String payerId,
    required String recipientId,
    required double amount,
    String? memo,
  }) async {
    return await ApiService.post<PaymentApi>(
      ApiConfig.roundPayments(roundId),
      data: {
        'payerId': payerId,
        'recipientId': recipientId,
        'amount': amount,
        'memo': memo,
      },
      fromJson: PaymentApi.fromJson,
    );
  }

  static Future<ApiResponse<PaymentApi>> updatePayment(
    String paymentId, {
    required String payerId,
    required String recipientId,
    required double amount,
    String? memo,
  }) async {
    return await ApiService.put<PaymentApi>(
      '${ApiConfig.payment(paymentId)}',
      data: {
        'payerId': payerId,
        'recipientId': recipientId,
        'amount': amount,
        'memo': memo,
      },
      fromJson: PaymentApi.fromJson,
    );
  }

  static Future<ApiResponse<void>> deletePayment(String paymentId) async {
    return await ApiService.delete<void>(ApiConfig.payment(paymentId));
  }

  // 정산 결과
  static Future<ApiResponse<GameSettlementApi>> getGameSettlement(String gameId) async {
    return await ApiService.get<GameSettlementApi>(
      ApiConfig.gameSettlement(gameId),
      fromJson: GameSettlementApi.fromJson,
    );
  }

  static Future<ApiResponse<GameSettlementApi>> calculateGameSettlement(String gameId) async {
    return await ApiService.post<GameSettlementApi>(
      ApiConfig.gameSettlementCalculate(gameId),
      fromJson: GameSettlementApi.fromJson,
    );
  }
}
