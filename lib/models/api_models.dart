import 'package:equatable/equatable.dart';

// 참가자 모델
class ParticipantApi extends Equatable {
  final String id;
  final String name;
  final String? avatar;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ParticipantApi({
    required this.id,
    required this.name,
    this.avatar,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory ParticipantApi.fromJson(Map<String, dynamic> json) {
    return ParticipantApi(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, name, avatar, isActive, createdAt, updatedAt];
}

// 게임 상태 열거형
enum GameStatusApi {
  inProgress('IN_PROGRESS'),
  completed('COMPLETED');

  const GameStatusApi(this.value);
  final String value;

  static GameStatusApi fromString(String value) {
    return GameStatusApi.values.firstWhere(
      (status) => status.value == value,
      orElse: () => GameStatusApi.inProgress,
    );
  }
}

// 게임 모델
class GameApi extends Equatable {
  final String id;
  final String title;
  final GameStatusApi status;
  final DateTime? createdAt;
  final DateTime? completedAt;
  final DateTime? updatedAt;
  final List<ParticipantApi> participants;

  const GameApi({
    required this.id,
    required this.title,
    required this.status,
    this.createdAt,
    this.completedAt,
    this.updatedAt,
    required this.participants,
  });

  factory GameApi.fromJson(Map<String, dynamic> json) {
    return GameApi(
      id: json['id'] as String,
      title: json['title'] as String,
      status: GameStatusApi.fromString(json['status'] as String),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      participants: (json['participants'] as List<dynamic>?)
          ?.map((p) => ParticipantApi.fromJson(p as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'status': status.value,
      'createdAt': createdAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'participants': participants.map((p) => p.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, title, status, createdAt, completedAt, updatedAt, participants];
}

// 게임 라운드 모델
class GameRoundApi extends Equatable {
  final String id;
  final String gameId;
  final int roundNumber;
  final String winnerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PaymentApi> payments;

  const GameRoundApi({
    required this.id,
    required this.gameId,
    required this.roundNumber,
    required this.winnerId,
    required this.createdAt,
    required this.updatedAt,
    required this.payments,
  });

  factory GameRoundApi.fromJson(Map<String, dynamic> json) {
    return GameRoundApi(
      id: json['id'] as String,
      gameId: json['gameId'] as String,
      roundNumber: json['roundNumber'] as int,
      winnerId: json['winnerId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      payments: (json['payments'] as List<dynamic>?)
          ?.map((p) => PaymentApi.fromJson(p as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameId': gameId,
      'roundNumber': roundNumber,
      'winnerId': winnerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'payments': payments.map((p) => p.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, gameId, roundNumber, winnerId, createdAt, updatedAt, payments];
}

// 지급 내역 모델
class PaymentApi extends Equatable {
  final String id;
  final String roundId;
  final String payerId;
  final String recipientId;
  final double amount;
  final String? memo;
  final DateTime createdAt;

  const PaymentApi({
    required this.id,
    required this.roundId,
    required this.payerId,
    required this.recipientId,
    required this.amount,
    this.memo,
    required this.createdAt,
  });

  factory PaymentApi.fromJson(Map<String, dynamic> json) {
    return PaymentApi(
      id: json['id'] as String,
      roundId: json['roundId'] as String,
      payerId: json['payerId'] as String,
      recipientId: json['recipientId'] as String,
      amount: (json['amount'] as num).toDouble(),
      memo: json['memo'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roundId': roundId,
      'payerId': payerId,
      'recipientId': recipientId,
      'amount': amount,
      'memo': memo,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, roundId, payerId, recipientId, amount, memo, createdAt];
}

// 정산 결과 모델
class GameSettlementApi extends Equatable {
  final String gameId;
  final String gameTitle;
  final double totalAmount;
  final List<ParticipantBalanceApi> participantBalances;
  final List<SettlementTransactionApi> transactions;
  final DateTime calculatedAt;

  const GameSettlementApi({
    required this.gameId,
    required this.gameTitle,
    required this.totalAmount,
    required this.participantBalances,
    required this.transactions,
    required this.calculatedAt,
  });

  factory GameSettlementApi.fromJson(Map<String, dynamic> json) {
    return GameSettlementApi(
      gameId: json['gameId'] as String,
      gameTitle: json['gameTitle'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      participantBalances: (json['participantBalances'] as List<dynamic>)
          .map((b) => ParticipantBalanceApi.fromJson(b as Map<String, dynamic>))
          .toList(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((t) => SettlementTransactionApi.fromJson(t as Map<String, dynamic>))
          .toList(),
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [gameId, gameTitle, totalAmount, participantBalances, transactions, calculatedAt];
}

// 참가자 잔액 모델
class ParticipantBalanceApi extends Equatable {
  final String participantId;
  final String participantName;
  final double totalPaid;
  final double totalReceived;
  final double balance;

  const ParticipantBalanceApi({
    required this.participantId,
    required this.participantName,
    required this.totalPaid,
    required this.totalReceived,
    required this.balance,
  });

  factory ParticipantBalanceApi.fromJson(Map<String, dynamic> json) {
    return ParticipantBalanceApi(
      participantId: json['participantId'] as String,
      participantName: json['participantName'] as String,
      totalPaid: (json['totalPaid'] as num).toDouble(),
      totalReceived: (json['totalReceived'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [participantId, participantName, totalPaid, totalReceived, balance];
}

// 정산 거래 모델
class SettlementTransactionApi extends Equatable {
  final String fromParticipantId;
  final String toParticipantId;
  final double amount;

  const SettlementTransactionApi({
    required this.fromParticipantId,
    required this.toParticipantId,
    required this.amount,
  });

  factory SettlementTransactionApi.fromJson(Map<String, dynamic> json) {
    return SettlementTransactionApi(
      fromParticipantId: json['fromParticipantId'] as String,
      toParticipantId: json['toParticipantId'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [fromParticipantId, toParticipantId, amount];
}

// 여행 정산 모델
class TravelSettlementApi extends Equatable {
  final String id;
  final String title;
  final double totalAmount;
  final GameStatusApi status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime updatedAt;
  final List<TravelExpenseApi> expenses;

  const TravelSettlementApi({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.completedAt,
    required this.updatedAt,
    required this.expenses,
  });

  factory TravelSettlementApi.fromJson(Map<String, dynamic> json) {
    return TravelSettlementApi(
      id: json['id'] as String,
      title: json['title'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: GameStatusApi.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      expenses: (json['expenses'] as List<dynamic>?)
          ?.map((e) => TravelExpenseApi.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [id, title, totalAmount, status, createdAt, completedAt, updatedAt, expenses];
}

// 여행 지출 모델
class TravelExpenseApi extends Equatable {
  final String id;
  final String settlementId;
  final String participantId;
  final double amount;
  final String? description;
  final DateTime createdAt;

  const TravelExpenseApi({
    required this.id,
    required this.settlementId,
    required this.participantId,
    required this.amount,
    this.description,
    required this.createdAt,
  });

  factory TravelExpenseApi.fromJson(Map<String, dynamic> json) {
    return TravelExpenseApi(
      id: json['id'] as String,
      settlementId: json['settlementId'] as String,
      participantId: json['participantId'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, settlementId, participantId, amount, description, createdAt];
}
