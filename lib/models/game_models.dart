import 'package:equatable/equatable.dart';

// 게임 상태 열거형
enum GameStatus {
  inProgress,  // 진행중
  completed,   // 완료
}

// 게임 모델
class Game extends Equatable {
  final String id;
  final String title;
  final List<Participant> participants;
  final List<GameRound> rounds;
  final GameStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Game({
    required this.id,
    required this.title,
    required this.participants,
    required this.rounds,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        participants,
        rounds,
        status,
        createdAt,
        completedAt,
      ];

  Game copyWith({
    String? id,
    String? title,
    List<Participant>? participants,
    List<GameRound>? rounds,
    GameStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      participants: participants ?? this.participants,
      rounds: rounds ?? this.rounds,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'participants': participants.map((p) => p.toJson()).toList(),
      'rounds': rounds.map((r) => r.toJson()).toList(),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      title: json['title'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((p) => Participant.fromJson(p as Map<String, dynamic>))
          .toList(),
      rounds: (json['rounds'] as List<dynamic>)
          .map((r) => GameRound.fromJson(r as Map<String, dynamic>))
          .toList(),
      status: GameStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => GameStatus.inProgress,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  // 게임이 완료되었는지 확인
  bool get isCompleted => status == GameStatus.completed;

  // 총 라운드 수
  int get totalRounds => rounds.length;

  // 총 지급 금액
  double get totalAmount {
    return rounds.fold(0.0, (sum, round) => sum + round.totalAmount);
  }
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'isActive': isActive,
    };
  }

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

// 게임 라운드 모델
class GameRound extends Equatable {
  final String id;
  final int roundNumber;
  final String winnerId; // 승자 ID
  final List<Payment> payments; // 지급 내역
  final DateTime createdAt;

  const GameRound({
    required this.id,
    required this.roundNumber,
    required this.winnerId,
    required this.payments,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, roundNumber, winnerId, payments, createdAt];

  GameRound copyWith({
    String? id,
    int? roundNumber,
    String? winnerId,
    List<Payment>? payments,
    DateTime? createdAt,
  }) {
    return GameRound(
      id: id ?? this.id,
      roundNumber: roundNumber ?? this.roundNumber,
      winnerId: winnerId ?? this.winnerId,
      payments: payments ?? this.payments,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // 라운드 총 지급 금액
  double get totalAmount {
    return payments.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  // 승자 이름 가져오기 (참가자 리스트에서)
  String getWinnerName(List<Participant> participants) {
    final winner = participants.firstWhere(
      (p) => p.id == winnerId,
      orElse: () => const Participant(id: '', name: '알 수 없음'),
    );
    return winner.name;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roundNumber': roundNumber,
      'winnerId': winnerId,
      'payments': payments.map((p) => p.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GameRound.fromJson(Map<String, dynamic> json) {
    return GameRound(
      id: json['id'] as String,
      roundNumber: json['roundNumber'] as int,
      winnerId: json['winnerId'] as String,
      payments: (json['payments'] as List<dynamic>)
          .map((p) => Payment.fromJson(p as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

// 지급 내역 모델
class Payment extends Equatable {
  final String id;
  final String payerId; // 지급자 ID
  final String recipientId; // 수령자 ID (승자)
  final double amount; // 지급 금액
  final String? memo; // 메모

  const Payment({
    required this.id,
    required this.payerId,
    required this.recipientId,
    required this.amount,
    this.memo,
  });

  @override
  List<Object?> get props => [id, payerId, recipientId, amount, memo];

  Payment copyWith({
    String? id,
    String? payerId,
    String? recipientId,
    double? amount,
    String? memo,
  }) {
    return Payment(
      id: id ?? this.id,
      payerId: payerId ?? this.payerId,
      recipientId: recipientId ?? this.recipientId,
      amount: amount ?? this.amount,
      memo: memo ?? this.memo,
    );
  }

  // 지급자 이름 가져오기
  String getPayerName(List<Participant> participants) {
    final payer = participants.firstWhere(
      (p) => p.id == payerId,
      orElse: () => const Participant(id: '', name: '알 수 없음'),
    );
    return payer.name;
  }

  // 수령자 이름 가져오기
  String getRecipientName(List<Participant> participants) {
    final recipient = participants.firstWhere(
      (p) => p.id == recipientId,
      orElse: () => const Participant(id: '', name: '알 수 없음'),
    );
    return recipient.name;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payerId': payerId,
      'recipientId': recipientId,
      'amount': amount,
      'memo': memo,
    };
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      payerId: json['payerId'] as String,
      recipientId: json['recipientId'] as String,
      amount: (json['amount'] as num).toDouble(),
      memo: json['memo'] as String?,
    );
  }
}

// 정산 결과 모델
class SettlementResult extends Equatable {
  final String gameId;
  final List<Participant> participants;
  final Map<String, double> netAmounts; // 참가자 ID -> 순 금액 (양수: 받을 금액, 음수: 지급할 금액)
  final List<SettlementTransaction> transactions; // 최적화된 거래 내역
  final double totalAmount;
  final DateTime calculatedAt;

  const SettlementResult({
    required this.gameId,
    required this.participants,
    required this.netAmounts,
    required this.transactions,
    required this.totalAmount,
    required this.calculatedAt,
  });

  @override
  List<Object?> get props => [
        gameId,
        participants,
        netAmounts,
        transactions,
        totalAmount,
        calculatedAt,
      ];

  // 참가자별 순 금액 가져오기
  double getNetAmount(String participantId) {
    return netAmounts[participantId] ?? 0.0;
  }

  // 받을 금액이 있는 참가자들
  List<Participant> get recipients {
    return participants.where((p) => getNetAmount(p.id) > 0).toList();
  }

  // 지급할 금액이 있는 참가자들
  List<Participant> get payers {
    return participants.where((p) => getNetAmount(p.id) < 0).toList();
  }
}

// 정산 거래 내역 모델
class SettlementTransaction extends Equatable {
  final String payerId;
  final String recipientId;
  final double amount;

  const SettlementTransaction({
    required this.payerId,
    required this.recipientId,
    required this.amount,
  });

  @override
  List<Object?> get props => [payerId, recipientId, amount];

  // 지급자 이름 가져오기
  String getPayerName(List<Participant> participants) {
    final payer = participants.firstWhere(
      (p) => p.id == payerId,
      orElse: () => const Participant(id: '', name: '알 수 없음'),
    );
    return payer.name;
  }

  // 수령자 이름 가져오기
  String getRecipientName(List<Participant> participants) {
    final recipient = participants.firstWhere(
      (p) => p.id == recipientId,
      orElse: () => const Participant(id: '', name: '알 수 없음'),
    );
    return recipient.name;
  }
}
