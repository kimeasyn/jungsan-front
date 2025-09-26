import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/layout/app_scaffold.dart';
import '../models/game_models.dart';
import 'game_participants_screen.dart';
import 'game_rounds_screen.dart';
import 'game_settlement_result_screen.dart';

class GameSettlementMainScreen extends StatefulWidget {
  const GameSettlementMainScreen({super.key});

  @override
  State<GameSettlementMainScreen> createState() => _GameSettlementMainScreenState();
}

class _GameSettlementMainScreenState extends State<GameSettlementMainScreen> {
  final List<Game> _games = [];

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  void _loadGames() {
    // TODO: 실제로는 SharedPreferences나 데이터베이스에서 로드
    // 임시 데이터
    setState(() {
      _games.addAll([
        Game(
          id: '1',
          title: '포커 게임',
          participants: [
            const Participant(id: '1', name: '김철수'),
            const Participant(id: '2', name: '이영희'),
            const Participant(id: '3', name: '박민수'),
            const Participant(id: '4', name: '최지영'),
          ],
          rounds: [],
          status: GameStatus.inProgress,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Game(
          id: '2',
          title: '골프 게임',
          participants: [
            const Participant(id: '5', name: '정민호'),
            const Participant(id: '6', name: '한소영'),
          ],
          rounds: [],
          status: GameStatus.completed,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          completedAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ]);
    });
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
    if (_games.isEmpty) {
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
        ..._games.map((game) => _buildGameCard(game)).toList(),
      ],
    );
  }

  Widget _buildGameCard(Game game) {
    final isCompleted = game.isCompleted;
    final participantCount = game.participants.length;
    final roundCount = game.rounds.length;
    final totalAmount = game.totalAmount;

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
    final result = await Navigator.of(context).push<Game?>(
      MaterialPageRoute(
        builder: (context) => const GameParticipantsScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        _games.add(result);
      });
    }
  }

  void _openGame(Game game) async {
    final result = await Navigator.of(context).push<Game?>(
      MaterialPageRoute(
        builder: (context) => GameRoundsScreen(game: game),
      ),
    );

    if (result != null) {
      setState(() {
        final index = _games.indexWhere((g) => g.id == result.id);
        if (index != -1) {
          _games[index] = result;
        }
      });
    }
  }

  void _showSettlementResult(Game game) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameSettlementResultScreen(game: game),
      ),
    );
  }
}
