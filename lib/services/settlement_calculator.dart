import '../models/game_models.dart';

class SettlementCalculator {
  /// 게임의 정산 결과를 계산합니다.
  static SettlementResult calculateSettlement(Game game) {
    // 1. 각 참가자별 순 금액 계산
    final Map<String, double> netAmounts = {};
    
    // 초기화
    for (final participant in game.participants) {
      netAmounts[participant.id] = 0.0;
    }

    // 2. 각 라운드의 지급 내역을 합산
    for (final round in game.rounds) {
      for (final payment in round.payments) {
        // 지급자는 음수, 수령자는 양수
        netAmounts[payment.payerId] = (netAmounts[payment.payerId] ?? 0.0) - payment.amount;
        netAmounts[payment.recipientId] = (netAmounts[payment.recipientId] ?? 0.0) + payment.amount;
      }
    }

    // 3. 최적화된 거래 내역 생성
    final transactions = _optimizeTransactions(netAmounts, game.participants);

    // 4. 총 금액 계산
    final totalAmount = game.totalAmount;

    return SettlementResult(
      gameId: game.id,
      participants: game.participants,
      netAmounts: netAmounts,
      transactions: transactions,
      totalAmount: totalAmount,
      calculatedAt: DateTime.now(),
    );
  }

  /// 거래 내역을 최적화합니다 (최소한의 거래로 정산)
  static List<SettlementTransaction> _optimizeTransactions(
    Map<String, double> netAmounts,
    List<Participant> participants,
  ) {
    final transactions = <SettlementTransaction>[];
    final amounts = Map<String, double>.from(netAmounts);

    // 받을 금액이 있는 참가자들 (양수)
    final creditors = <String, double>{};
    // 지급할 금액이 있는 참가자들 (음수)
    final debtors = <String, double>{};

    for (final entry in amounts.entries) {
      if (entry.value > 0) {
        creditors[entry.key] = entry.value;
      } else if (entry.value < 0) {
        debtors[entry.key] = -entry.value; // 양수로 변환
      }
    }

    // 최적화 알고리즘: 각 채권자에 대해 가장 큰 채무자부터 정산
    for (final creditorEntry in creditors.entries) {
      final creditorId = creditorEntry.key;
      double remainingCredit = creditorEntry.value;

      while (remainingCredit > 0.01) { // 소수점 오차 방지
        // 가장 큰 채무를 가진 채무자 찾기
        String? largestDebtorId;
        double largestDebt = 0;

        for (final debtorEntry in debtors.entries) {
          if (debtorEntry.value > largestDebt) {
            largestDebtorId = debtorEntry.key;
            largestDebt = debtorEntry.value;
          }
        }

        if (largestDebtorId == null) break;

        // 거래 금액 결정
        final transactionAmount = remainingCredit < largestDebt 
            ? remainingCredit 
            : largestDebt;

        // 거래 생성
        transactions.add(SettlementTransaction(
          payerId: largestDebtorId,
          recipientId: creditorId,
          amount: transactionAmount,
        ));

        // 금액 업데이트
        remainingCredit -= transactionAmount;
        debtors[largestDebtorId] = largestDebt - transactionAmount;

        // 채무가 0이 되면 제거
        if (debtors[largestDebtorId]! < 0.01) {
          debtors.remove(largestDebtorId);
        }
      }
    }

    return transactions;
  }

  /// 라운드의 유효성을 검사합니다.
  static String? validateRound(GameRound round, List<Participant> participants) {
    // 1. 승자가 참가자 목록에 있는지 확인
    if (!participants.any((p) => p.id == round.winnerId)) {
      return '승자가 참가자 목록에 없습니다.';
    }

    // 2. 지급 내역이 있는지 확인
    if (round.payments.isEmpty) {
      return '최소 하나의 지급 내역이 필요합니다.';
    }

    // 3. 지급자들이 모두 참가자 목록에 있는지 확인
    for (final payment in round.payments) {
      if (!participants.any((p) => p.id == payment.payerId)) {
        return '지급자가 참가자 목록에 없습니다.';
      }
      if (payment.recipientId != round.winnerId) {
        return '지급 수령자가 승자와 일치하지 않습니다.';
      }
    }

    // 4. 최소 하나의 양수 지급이 있는지 확인
    final hasPositivePayment = round.payments.any((p) => p.amount > 0);
    if (!hasPositivePayment) {
      return '최소 하나의 양수 지급이 필요합니다.';
    }

    // 5. 음수 지급이 없는지 확인
    final hasNegativePayment = round.payments.any((p) => p.amount < 0);
    if (hasNegativePayment) {
      return '지급 금액은 0 이상이어야 합니다.';
    }

    return null; // 유효함
  }

  /// 게임의 유효성을 검사합니다.
  static String? validateGame(Game game) {
    // 1. 참가자 수 확인
    if (game.participants.isEmpty) {
      return '최소 1명의 참가자가 필요합니다.';
    }
    if (game.participants.length > 10) {
      return '최대 10명까지만 참가할 수 있습니다.';
    }

    // 2. 참가자 이름 중복 확인
    final names = game.participants.map((p) => p.name).toList();
    final uniqueNames = names.toSet();
    if (names.length != uniqueNames.length) {
      return '참가자 이름이 중복됩니다.';
    }

    // 3. 각 라운드 유효성 확인
    for (int i = 0; i < game.rounds.length; i++) {
      final round = game.rounds[i];
      final error = validateRound(round, game.participants);
      if (error != null) {
        return '${i + 1}라운드: $error';
      }
    }

    return null; // 유효함
  }
}
