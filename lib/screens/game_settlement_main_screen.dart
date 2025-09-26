import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/layout/app_scaffold.dart';
import '../models/game_models.dart';
import '../models/api_models.dart';
import '../services/game_api_service.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import 'game_participants_screen.dart';
import 'game_rounds_screen.dart';
import 'game_settlement_result_screen.dart';

class GameSettlementMainScreen extends StatefulWidget {
  const GameSettlementMainScreen({super.key});

  @override
  State<GameSettlementMainScreen> createState() => _GameSettlementMainScreenState();
}

class _GameSettlementMainScreenState extends State<GameSettlementMainScreen> {
  List<GameApi> _apiGames = [];
  List<Game> _localGames = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 백엔드에서 게임 목록 가져오기
      final response = await GameApiService.getGames();
      if (response.isSuccess) {
        setState(() {
          _apiGames = response.data ?? [];
          _isLoading = false;
        });
        print('백엔드에서 ${_apiGames.length}개의 게임을 불러왔습니다');
      } else {
        setState(() {
          _errorMessage = response.errorMessage ?? '게임 목록을 불러올 수 없습니다';
          _isLoading = false;
        });
        print('백엔드 게임 목록 로드 실패: ${response.errorMessage}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = '게임 목록을 불러오는 중 오류가 발생했습니다: $e';
        _isLoading = false;
      });
      print('게임 목록 로드 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '게임 정산',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 게임 만들기 버튼
            _buildCreateGameButton(),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 게임 목록
            _buildGamesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateGameButton() {
    return AppButton(
      text: '게임 만들기',
      type: AppButtonType.primary,
      size: AppButtonSize.large,
      isFullWidth: true,
      icon: LucideIcons.plus,
      onPressed: _createNewGame,
    );
  }

  Widget _buildGamesList() {
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

    if (_apiGames.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '게임 목록',
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        ..._apiGames.map((game) => _buildGameCard(game)).toList(),
      ],
    );
  }

  Widget _buildGameCard(GameApi game) {
    final isCompleted = game.status == GameStatusApi.completed;
    final participantCount = game.participants.length;
    final roundCount = 0; // API 모델에는 rounds가 없으므로 0으로 설정
    final totalAmount = 0.0; // API 모델에는 totalAmount가 없으므로 0으로 설정

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      onTap: () => _openGame(game),
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
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: Icon(
                  LucideIcons.gamepad2,
                  size: 24,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$participantCount명 참여 • ${roundCount}라운드',
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
                      isCompleted ? '완료' : '진행중',
                      style: AppTypography.small.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${totalAmount.toStringAsFixed(0).replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},',
                    )}원',
                    style: AppTypography.captionMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (totalAmount > 0) ...[
            const SizedBox(height: AppTheme.spacingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '총 정산 금액',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${totalAmount.toStringAsFixed(0).replaceAllMapped(
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
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return AppCard(
      child: Column(
        children: [
          Icon(
            LucideIcons.gamepad2,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            '아직 게임이 없습니다',
            style: AppTypography.h4.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            '게임 만들기 버튼을 눌러\n새로운 게임을 시작해보세요!',
            style: AppTypography.body.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _createNewGame() async {
    final result = await Navigator.of(context).push<GameApi?>(
      MaterialPageRoute(
        builder: (context) => const GameParticipantsScreen(),
      ),
    );

    if (result != null) {
      _loadGames(); // 게임 목록 새로고침
    }
  }

  void _openGame(GameApi game) async {
    // GameApi를 Game 모델로 변환 (임시)
    final gameModel = Game(
      id: game.id,
      title: game.title,
      participants: game.participants.map((p) => Participant(
        id: p.id,
        name: p.name,
        avatar: p.avatar,
        isActive: p.isActive,
      )).toList(),
      rounds: [], // API에서 라운드 정보를 별도로 가져와야 함
      status: game.status == GameStatusApi.completed 
          ? GameStatus.completed 
          : GameStatus.inProgress,
      createdAt: game.createdAt ?? DateTime.now(),
      completedAt: game.completedAt,
    );

    final result = await Navigator.of(context).push<Game?>(
      MaterialPageRoute(
        builder: (context) => GameRoundsScreen(game: gameModel),
      ),
    );

    if (result != null) {
      // 게임 목록 새로고침
      _loadGames();
    }
  }

  void _showSettlementResult(GameApi game) {
    // GameApi를 Game 모델로 변환 (임시)
    final gameModel = Game(
      id: game.id,
      title: game.title,
      participants: game.participants.map((p) => Participant(
        id: p.id,
        name: p.name,
        avatar: p.avatar,
        isActive: p.isActive,
      )).toList(),
      rounds: [], // API에서 라운드 정보를 별도로 가져와야 함
      status: game.status == GameStatusApi.completed 
          ? GameStatus.completed 
          : GameStatus.inProgress,
      createdAt: game.createdAt ?? DateTime.now(),
      completedAt: game.completedAt,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameSettlementResultScreen(game: gameModel),
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
            '게임 목록을 불러올 수 없습니다',
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
            onPressed: _loadGames,
          ),
        ],
      ),
    );
  }
}
