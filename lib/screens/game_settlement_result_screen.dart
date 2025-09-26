import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/layout/app_scaffold.dart';
import '../models/game_models.dart';
import '../services/settlement_calculator.dart';

class GameSettlementResultScreen extends StatelessWidget {
  final Game game;

  const GameSettlementResultScreen({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final settlementResult = SettlementCalculator.calculateSettlement(game);

    return AppScaffold(
      title: '정산 결과',
      actions: [
        IconButton(
          onPressed: () => _shareResult(context),
          icon: const Icon(LucideIcons.share),
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 게임 요약
            _buildGameSummary(settlementResult),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 정산 결과
            _buildSettlementResult(settlementResult),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 액션 버튼들
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGameSummary(SettlementResult result) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '게임 요약',
            style: AppTypography.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                '참가자',
                '${game.participants.length}명',
                LucideIcons.users,
                AppColors.secondary,
              ),
              _buildSummaryItem(
                '라운드',
                '${game.rounds.length}개',
                LucideIcons.trophy,
                AppColors.primary,
              ),
              _buildSummaryItem(
                '총 금액',
                '${result.totalAmount.toStringAsFixed(0).replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                )}원',
                LucideIcons.dollarSign,
                AppColors.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettlementResult(SettlementResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '정산 결과',
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        
        // 참가자별 순 금액
        _buildNetAmounts(result),
        const SizedBox(height: AppTheme.spacingL),
        
        // 최적화된 거래 내역
        _buildTransactions(result),
      ],
    );
  }

  Widget _buildNetAmounts(SettlementResult result) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '참가자별 순 금액',
            style: AppTypography.h4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          ...result.participants.map((participant) {
            final netAmount = result.getNetAmount(participant.id);
            final isPositive = netAmount > 0;
            final isZero = netAmount == 0;
            
            return Container(
              margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: isZero 
                    ? AppColors.neutralLight
                    : (isPositive ? AppColors.accent.withOpacity(0.1) : AppColors.error.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
                border: Border.all(
                  color: isZero 
                      ? AppColors.border
                      : (isPositive ? AppColors.accent : AppColors.error),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: isZero 
                        ? AppColors.textTertiary
                        : (isPositive ? AppColors.accent : AppColors.error),
                    child: Icon(
                      isZero 
                          ? LucideIcons.minus
                          : (isPositive ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight),
                      size: 16,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          participant.name,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isZero 
                              ? '정산 완료'
                              : (isPositive ? '받을 금액' : '지급할 금액'),
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    isZero 
                        ? '0원'
                        : '${isPositive ? '+' : ''}${netAmount.abs().toStringAsFixed(0).replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        )}원',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isZero 
                          ? AppColors.textSecondary
                          : (isPositive ? AppColors.accent : AppColors.error),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTransactions(SettlementResult result) {
    if (result.transactions.isEmpty) {
      return AppCard(
        child: Column(
          children: [
            Icon(
              LucideIcons.checkCircle,
              size: 48,
              color: AppColors.accent,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              '정산이 완료되었습니다!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              '모든 참가자의 순 금액이 0원입니다.',
              style: AppTypography.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '최적화된 거래 내역',
            style: AppTypography.h4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            '다음과 같이 거래하시면 최소한의 거래로 정산할 수 있습니다.',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          ...result.transactions.map((transaction) {
            final payerName = transaction.getPayerName(result.participants);
            final recipientName = transaction.getRecipientName(result.participants);
            
            return Container(
              margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppColors.neutralLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.arrowRight,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: Text(
                      '$payerName → $recipientName',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${transaction.amount.toStringAsFixed(0).replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},',
                    )}원',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: '결과 공유하기',
          type: AppButtonType.primary,
          size: AppButtonSize.large,
          isFullWidth: true,
          icon: LucideIcons.share,
          onPressed: () => _shareResult(context),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: '게임 수정',
                type: AppButtonType.outline,
                size: AppButtonSize.medium,
                icon: LucideIcons.edit,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: AppButton(
                text: '새 게임',
                type: AppButtonType.outline,
                size: AppButtonSize.medium,
                icon: LucideIcons.plus,
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _shareResult(BuildContext context) {
    // TODO: 공유 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('공유 기능은 곧 구현됩니다'),
      ),
    );
  }
}
