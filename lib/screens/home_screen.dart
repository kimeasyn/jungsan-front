import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/layout/app_scaffold.dart';
import '../routes/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '정산',
      actions: [
        IconButton(
          onPressed: () => context.go(AppRouter.history),
          icon: const Icon(LucideIcons.history),
        ),
        IconButton(
          onPressed: () => context.go(AppRouter.profile),
          icon: const Icon(LucideIcons.user),
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(context),
            const SizedBox(height: AppTheme.spacingXL),
            
            // Settlement Mode Selection
            _buildSettlementModeSection(context),
            const SizedBox(height: AppTheme.spacingXL),
            
            // Recent Settlements
            _buildRecentSettlementsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '안녕하세요! 👋',
            style: AppTypography.h2.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            '간편하게 정산을 시작해보세요',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textOnPrimary.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementModeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '정산 모드 선택',
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Row(
          children: [
            Expanded(
              child: _buildModeCard(
                context: context,
                title: '여행 정산',
                subtitle: '여행 경비를\n공동으로 정산',
                icon: LucideIcons.mapPin,
                color: AppColors.primary,
                onTap: () => context.go(AppRouter.travelSettlement),
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: _buildModeCard(
                context: context,
                title: '게임 정산',
                subtitle: '게임 결과를\n금액으로 정산',
                icon: LucideIcons.gamepad2,
                color: AppColors.secondary,
                onTap: () => context.go(AppRouter.gameSettlement),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      isClickable: true,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: Icon(
              icon,
              size: 30,
              color: color,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            title,
            style: AppTypography.h4.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            subtitle,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSettlementsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '최근 정산 내역',
              style: AppTypography.h3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => context.go(AppRouter.history),
              child: Text(
                '전체 보기',
                style: AppTypography.captionMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingM),
        _buildRecentSettlementsList(context),
      ],
    );
  }

  Widget _buildRecentSettlementsList(BuildContext context) {
    // 임시 데이터 - 실제로는 상태 관리에서 가져와야 함
    final recentSettlements = [
      {
        'title': '제주도 여행',
        'type': '여행',
        'amount': 450000,
        'participants': 4,
        'date': '2024-01-15',
        'status': '완료',
      },
      {
        'title': '포커 게임',
        'type': '게임',
        'amount': 120000,
        'participants': 6,
        'date': '2024-01-12',
        'status': '완료',
      },
      {
        'title': '부산 여행',
        'type': '여행',
        'amount': 320000,
        'participants': 3,
        'date': '2024-01-10',
        'status': '진행중',
      },
    ];

    if (recentSettlements.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: recentSettlements
          .map((settlement) => _buildSettlementCard(context, settlement))
          .toList(),
    );
  }

  Widget _buildSettlementCard(BuildContext context, Map<String, dynamic> settlement) {
    final isCompleted = settlement['status'] == '완료';
    final typeColor = settlement['type'] == '여행' ? AppColors.primary : AppColors.secondary;
    
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      onTap: () {
        // 정산 상세 페이지로 이동
        if (isCompleted) {
          context.go('${AppRouter.settlementResult}/1');
        }
      },
      isClickable: isCompleted,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            child: Icon(
              settlement['type'] == '여행' ? LucideIcons.mapPin : LucideIcons.gamepad2,
              size: 24,
              color: typeColor,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  settlement['title'],
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${settlement['participants']}명 • ${settlement['date']}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${settlement['amount'].toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                )}원',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.accent : AppColors.warning,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  settlement['status'],
                  style: AppTypography.small.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Icon(
            LucideIcons.receipt,
            size: 48,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            '아직 정산 내역이 없습니다',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            '위의 버튼을 눌러 정산을 시작해보세요!',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
