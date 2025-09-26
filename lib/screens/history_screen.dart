import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_input.dart';
import '../widgets/layout/app_scaffold.dart';
import '../routes/app_router.dart';
import '../services/game_api_service.dart';
import '../services/travel_api_service.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = '전체';
  final List<String> _filters = ['전체', '여행', '게임', '완료', '진행중'];
  
  List<GameApi> _games = [];
  List<TravelSettlementApi> _travelSettlements = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSettlements();
  }

  Future<void> _loadSettlements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final futures = await Future.wait([
        GameApiService.getGames(),
        TravelApiService.getTravelSettlements(),
      ]);

      final gamesResponse = futures[0] as ApiResponse<List<GameApi>>;
      final travelResponse = futures[1] as ApiResponse<List<TravelSettlementApi>>;

      setState(() {
        if (gamesResponse.isSuccess) {
          _games = gamesResponse.data ?? [];
        }
        if (travelResponse.isSuccess) {
          _travelSettlements = travelResponse.data ?? [];
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
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingXL),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    // 게임과 여행 정산을 합쳐서 최근 순으로 정렬
    final allSettlements = <Map<String, dynamic>>[];
    
    // 게임 정산 추가
    for (final game in _games) {
      allSettlements.add({
        'id': game.id,
        'title': game.title,
        'type': '게임',
        'amount': 0, // 게임은 라운드별로 금액이 다름
        'participants': game.participants.length,
        'date': game.createdAt?.toIso8601String().substring(0, 10) ?? '날짜 없음',
        'status': game.status == GameStatusApi.completed ? '완료' : '진행중',
        'description': '게임 정산',
        'game': game,
      });
    }
    
    // 여행 정산 추가
    for (final travel in _travelSettlements) {
      allSettlements.add({
        'id': travel.id,
        'title': travel.title,
        'type': '여행',
        'amount': travel.totalAmount,
        'participants': 0, // 여행 정산은 참가자 수가 다름
        'date': travel.createdAt.toIso8601String().substring(0, 10),
        'status': travel.status == GameStatusApi.completed ? '완료' : '진행중',
        'description': '여행 정산',
        'travel': travel,
      });
    }

    // 날짜순으로 정렬 (최신순)
    allSettlements.sort((a, b) => b['date'].compareTo(a['date']));

    // 필터링 적용
    List<Map<String, dynamic>> filteredSettlements = allSettlements.where((settlement) {
      // 검색어 필터링
      if (_searchController.text.isNotEmpty) {
        final searchTerm = _searchController.text.toLowerCase();
        if (!settlement['title'].toString().toLowerCase().contains(searchTerm) &&
            !settlement['description'].toString().toLowerCase().contains(searchTerm)) {
          return false;
        }
      }

      // 타입 필터링
      if (_selectedFilter == '여행' && settlement['type'] != '여행') return false;
      if (_selectedFilter == '게임' && settlement['type'] != '게임') return false;
      if (_selectedFilter == '완료' && settlement['status'] != '완료') return false;
      if (_selectedFilter == '진행중' && settlement['status'] != '진행중') return false;

      return true;
    }).toList();

    if (filteredSettlements.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      itemCount: filteredSettlements.length,
      itemBuilder: (context, index) {
        final settlement = filteredSettlements[index];
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
                settlement['participants'] > 0 
                    ? '${settlement['participants']}명 참여'
                    : '정산',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                settlement['amount'] > 0
                    ? '${settlement['amount'].toStringAsFixed(0).replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},',
                      )}원'
                    : '게임',
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

  Widget _buildErrorState() {
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
          ElevatedButton.icon(
            onPressed: _loadSettlements,
            icon: const Icon(LucideIcons.refreshCw),
            label: const Text('다시 시도'),
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
