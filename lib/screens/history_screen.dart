import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_input.dart';
import '../widgets/layout/app_scaffold.dart';
import '../routes/app_router.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = '전체';
  final List<String> _filters = ['전체', '여행', '게임', '완료', '진행중'];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '정산 내역',
      body: Column(
        children: [
          // 검색 및 필터 섹션
          _buildSearchAndFilterSection(),
          
          // 정산 내역 리스트
          Expanded(
            child: _buildSettlementsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          // 검색 입력
          AppSearchInput(
            controller: _searchController,
            hint: '정산 내역 검색',
            onChanged: (value) {
              setState(() {
                // TODO: 검색 로직 구현
              });
            },
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          // 필터 버튼들
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacingS),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: AppTypography.captionMedium.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementsList() {
    // 임시 데이터 - 실제로는 상태 관리에서 가져와야 함
    final settlements = [
      {
        'id': '1',
        'title': '제주도 여행',
        'type': '여행',
        'amount': 450000,
        'participants': 4,
        'date': '2024-01-15',
        'status': '완료',
        'description': '제주도 3박 4일 여행 정산',
      },
      {
        'id': '2',
        'title': '포커 게임',
        'type': '게임',
        'amount': 120000,
        'participants': 6,
        'date': '2024-01-12',
        'status': '완료',
        'description': '포커 게임 정산',
      },
      {
        'id': '3',
        'title': '부산 여행',
        'type': '여행',
        'amount': 320000,
        'participants': 3,
        'date': '2024-01-10',
        'status': '진행중',
        'description': '부산 1박 2일 여행 정산',
      },
      {
        'id': '4',
        'title': '골프 게임',
        'type': '게임',
        'amount': 80000,
        'participants': 4,
        'date': '2024-01-08',
        'status': '완료',
        'description': '골프 게임 정산',
      },
    ];

    if (settlements.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      itemCount: settlements.length,
      itemBuilder: (context, index) {
        final settlement = settlements[index];
        return _buildSettlementCard(settlement);
      },
    );
  }

  Widget _buildSettlementCard(Map<String, dynamic> settlement) {
    final isCompleted = settlement['status'] == '완료';
    final typeColor = settlement['type'] == '여행' ? AppColors.primary : AppColors.secondary;
    
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      onTap: () {
        if (isCompleted) {
          // 완료된 정산은 결과 페이지로 이동
          Navigator.of(context).pushNamed(
            '${AppRouter.settlementResult}/${settlement['id']}',
          );
        } else {
          // 진행중인 정산은 해당 정산 페이지로 이동
          if (settlement['type'] == '여행') {
            Navigator.of(context).pushNamed(AppRouter.travelSettlement);
          } else {
            Navigator.of(context).pushNamed(AppRouter.gameSettlement);
          }
        }
      },
      isClickable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      settlement['description'],
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
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
                  const SizedBox(height: 4),
                  Text(
                    settlement['date'],
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${settlement['participants']}명 참여',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.history,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            '정산 내역이 없습니다',
            style: AppTypography.h4.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            '첫 번째 정산을 시작해보세요!',
            style: AppTypography.body.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRouter.home);
            },
            icon: const Icon(LucideIcons.plus),
            label: const Text('정산 시작하기'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
