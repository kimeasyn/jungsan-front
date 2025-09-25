import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/layout/app_scaffold.dart';

class SettlementResultScreen extends StatelessWidget {
  final String settlementId;

  const SettlementResultScreen({
    super.key,
    required this.settlementId,
  });

  @override
  Widget build(BuildContext context) {
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
            // 요약 정보
            _buildSummarySection(),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 정산 결과
            _buildSettlementResults(),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 액션 버튼들
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    // 임시 데이터 - 실제로는 상태 관리에서 가져와야 함
    final totalAmount = 450000;
    final participantCount = 4;
    final settlementType = '여행';
    
    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '정산 요약',
                style: AppTypography.h3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: settlementType == '여행' 
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  settlementType,
                  style: AppTypography.captionMedium.copyWith(
                    color: settlementType == '여행' 
                        ? AppColors.primary
                        : AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                '총 금액',
                '${totalAmount.toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                )}원',
                LucideIcons.dollarSign,
                AppColors.primary,
              ),
              _buildSummaryItem(
                '참가자',
                '${participantCount}명',
                LucideIcons.users,
                AppColors.secondary,
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
        Icon(
          icon,
          size: 32,
          color: color,
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          value,
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingXS),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettlementResults() {
    // 임시 데이터 - 실제로는 상태 관리에서 가져와야 함
    final results = [
      {'name': '김철수', 'amount': 150000, 'type': 'receive'},
      {'name': '이영희', 'amount': 75000, 'type': 'receive'},
      {'name': '박민수', 'amount': -50000, 'type': 'pay'},
      {'name': '최지영', 'amount': -175000, 'type': 'pay'},
    ];

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
        ...results.map((result) => _buildResultCard(result)).toList(),
      ],
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result) {
    final isReceive = result['type'] == 'receive';
    final amount = result['amount'] as int;
    final absAmount = amount.abs();
    
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isReceive 
                  ? AppColors.accent.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            child: Icon(
              isReceive ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
              size: 24,
              color: isReceive ? AppColors.accent : AppColors.error,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result['name'],
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isReceive ? '받을 금액' : '내야 할 금액',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isReceive ? '+' : '-'}${absAmount.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            )}원',
            style: AppTypography.h4.copyWith(
              color: isReceive ? AppColors.accent : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
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
                text: '다시 정산',
                type: AppButtonType.outline,
                size: AppButtonSize.medium,
                icon: LucideIcons.refreshCw,
                onPressed: () => _restartSettlement(context),
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: AppButton(
                text: '내역 저장',
                type: AppButtonType.outline,
                size: AppButtonSize.medium,
                icon: LucideIcons.save,
                onPressed: () => _saveSettlement(context),
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

  void _restartSettlement(BuildContext context) {
    // TODO: 다시 정산 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('다시 정산 기능은 곧 구현됩니다'),
      ),
    );
  }

  void _saveSettlement(BuildContext context) {
    // TODO: 내역 저장 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('내역이 저장되었습니다'),
      ),
    );
  }
}
