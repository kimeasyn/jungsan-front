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
import '../services/game_api_service.dart';
import '../services/travel_api_service.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GameApi> _recentGames = [];
  List<TravelSettlementApi> _recentTravelSettlements = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRecentSettlements();
  }

  Future<void> _loadRecentSettlements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 게임 정산과 여행 정산을 병렬로 로드
      final futures = await Future.wait([
        GameApiService.getGames(),
        TravelApiService.getTravelSettlements(),
      ]);

      final gamesResponse = futures[0] as ApiResponse<List<GameApi>>;
      final travelResponse = futures[1] as ApiResponse<List<TravelSettlementApi>>;

      setState(() {
        if (gamesResponse.isSuccess) {
          _recentGames = gamesResponse.data ?? [];
        }
        if (travelResponse.isSuccess) {
          _recentTravelSettlements = travelResponse.data ?? [];
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '데이터를 불러오는 중 오류가 발생했습니다: $e';
        _isLoading = false;
      });
    }
  }

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
          onPressed: () => context.go(AppRouter.apiTest),
          icon: const Icon(LucideIcons.wifi),
          tooltip: 'API 테스트',
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
            Expanded(
              child: Text(
                '최근 정산 내역',
                style: AppTypography.h3.copyWith(
                  color: AppColors.textPrimary,
                ),
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
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingXL),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState(context);
    }

    // 게임과 여행 정산을 합쳐서 최근 순으로 정렬
    final allSettlements = <Map<String, dynamic>>[];
    
    // 게임 정산 추가
    for (final game in _recentGames.take(3)) {
      allSettlements.add({
        'id': game.id,
        'title': game.title,
        'type': '게임',
        'amount': 0, // 게임은 라운드별로 금액이 다름
        'participants': game.participants.length,
        'date': game.createdAt?.toIso8601String().substring(0, 10) ?? '날짜 없음',
        'status': game.status == GameStatusApi.completed ? '완료' : '진행중',
        'game': game,
      });
    }
    
    // 여행 정산 추가
    for (final travel in _recentTravelSettlements.take(3)) {
      allSettlements.add({
        'id': travel.id,
        'title': travel.title,
        'type': '여행',
        'amount': travel.totalAmount,
        'participants': 0, // 여행 정산은 참가자 수가 다름
        'date': travel.createdAt.toIso8601String().substring(0, 10),
        'status': travel.status == GameStatusApi.completed ? '완료' : '진행중',
        'travel': travel,
      });
    }

    // 날짜순으로 정렬 (최신순)
    allSettlements.sort((a, b) => b['date'].compareTo(a['date']));

    if (allSettlements.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: allSettlements
          .take(5) // 최대 5개만 표시
          .map((settlement) => _buildSettlementCard(context, settlement))
          .toList(),
    );
  }

  Widget _buildSettlementCard(BuildContext context, Map<String, dynamic> settlement) {
    final isCompleted = settlement['status'] == '완료';
    final typeColor = settlement['type'] == '여행' ? AppColors.primary : AppColors.secondary;
    final amount = settlement['amount'] as double;
    final participants = settlement['participants'] as int;
    
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      onTap: () {
        // 정산 상세 페이지로 이동
        if (isCompleted) {
          context.go('${AppRouter.settlementResult}/${settlement['id']}');
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
                  participants > 0 
                      ? '${participants}명 • ${settlement['date']}'
                      : settlement['date'],
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
              if (amount > 0)
                Text(
                  '${amount.toStringAsFixed(0).replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (Match m) => '${m[1]},',
                  )}원',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                Text(
                  '게임',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
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

  Widget _buildErrorState(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Icon(
            LucideIcons.alertCircle,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            '데이터를 불러올 수 없습니다',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            _errorMessage ?? '알 수 없는 오류가 발생했습니다',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingM),
          AppButton(
            text: '다시 시도',
            type: AppButtonType.outline,
            size: AppButtonSize.small,
            onPressed: _loadRecentSettlements,
          ),
        ],
      ),
    );
  }
}
