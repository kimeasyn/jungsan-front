import 'package:equatable/equatable.dart';

// 정산 타입 열거형
enum SettlementType {
  travel,
  game,
}

// 참가자 모델
class Participant extends Equatable {
  final String id;
  final String name;
  final String? avatar;
  final bool isActive;

  const Participant({
    required this.id,
    required this.name,
    this.avatar,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, avatar, isActive];

  Participant copyWith({
    String? id,
    String? name,
    String? avatar,
    bool? isActive,
  }) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isActive: isActive ?? this.isActive,
    );
  }
}

// 여행 비용 모델
class TravelExpense extends Equatable {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String payerId; // 결제자 ID
  final List<String> participants; // 참가자 ID 리스트
  final String? memo;
  final DateTime createdAt;

  const TravelExpense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.payerId,
    required this.participants,
    this.memo,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        category,
        payerId,
        participants,
        memo,
        createdAt,
      ];

  TravelExpense copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    String? payerId,
    List<String>? participants,
    String? memo,
    DateTime? createdAt,
  }) {
    return TravelExpense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      payerId: payerId ?? this.payerId,
      participants: participants ?? this.participants,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// 게임 판별 모델
class GameRound extends Equatable {
  final String id;
  final int roundNumber;
  final Map<String, double> scores; // 참가자 ID -> 점수
  final DateTime createdAt;

  const GameRound({
    required this.id,
    required this.roundNumber,
    required this.scores,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, roundNumber, scores, createdAt];

  GameRound copyWith({
    String? id,
    int? roundNumber,
    Map<String, double>? scores,
    DateTime? createdAt,
  }) {
    return GameRound(
      id: id ?? this.id,
      roundNumber: roundNumber ?? this.roundNumber,
      scores: scores ?? this.scores,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// 정산 결과 모델
class SettlementResult extends Equatable {
  final String id;
  final SettlementType type;
  final List<Participant> participants;
  final Map<String, double> amounts; // 참가자 ID -> 정산 금액 (양수: 받을 금액, 음수: 내야 할 금액)
  final double totalAmount;
  final DateTime createdAt;
  final DateTime? completedAt;

  const SettlementResult({
    required this.id,
    required this.type,
    required this.participants,
    required this.amounts,
    required this.totalAmount,
    required this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        participants,
        amounts,
        totalAmount,
        createdAt,
        completedAt,
      ];

  SettlementResult copyWith({
    String? id,
    SettlementType? type,
    List<Participant>? participants,
    Map<String, double>? amounts,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return SettlementResult(
      id: id ?? this.id,
      type: type ?? this.type,
      participants: participants ?? this.participants,
      amounts: amounts ?? this.amounts,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

// 정산 세션 모델 (진행 중인 정산)
class SettlementSession extends Equatable {
  final String id;
  final SettlementType type;
  final List<Participant> participants;
  final List<TravelExpense>? travelExpenses;
  final List<GameRound>? gameRounds;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SettlementSession({
    required this.id,
    required this.type,
    required this.participants,
    this.travelExpenses,
    this.gameRounds,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        participants,
        travelExpenses,
        gameRounds,
        createdAt,
        updatedAt,
      ];

  SettlementSession copyWith({
    String? id,
    SettlementType? type,
    List<Participant>? participants,
    List<TravelExpense>? travelExpenses,
    List<GameRound>? gameRounds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SettlementSession(
      id: id ?? this.id,
      type: type ?? this.type,
      participants: participants ?? this.participants,
      travelExpenses: travelExpenses ?? this.travelExpenses,
      gameRounds: gameRounds ?? this.gameRounds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
