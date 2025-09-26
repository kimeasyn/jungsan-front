import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/common/app_input.dart';
import '../widgets/layout/app_scaffold.dart';
import '../models/game_models.dart';
import '../models/api_models.dart';
import '../services/game_api_service.dart';
import '../services/api_service.dart';
import 'game_rounds_screen.dart';

class GameParticipantsScreen extends StatefulWidget {
  final Game? game;
  
  const GameParticipantsScreen({super.key, this.game});

  @override
  State<GameParticipantsScreen> createState() => _GameParticipantsScreenState();
}

class _GameParticipantsScreenState extends State<GameParticipantsScreen> {
  late List<Participant> _participants;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _participants = widget.game?.participants ?? [];
    _titleController = TextEditingController(text: widget.game?.title ?? '새 게임');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '참가자 설정',
      actions: [],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 게임 제목 입력
            _buildGameTitleSection(),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 참가자 섹션
            _buildParticipantsSection(),
            const SizedBox(height: AppTheme.spacingXL),
            
          ],
        ),
      ),
    );
  }

  Widget _buildGameTitleSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '게임 제목',
            style: AppTypography.h4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          AppInput(
            controller: _titleController,
            hint: '게임 제목을 입력하세요',
            onChanged: (value) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '참가자 (${_participants.length}/10)',
              style: AppTypography.h3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            AppButton(
              text: '참가자 추가',
              type: AppButtonType.outline,
              size: AppButtonSize.small,
              icon: LucideIcons.plus,
              onPressed: _participants.length < 10 ? _addParticipant : null,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingM),
        if (_participants.isEmpty)
          _buildEmptyParticipants()
        else
          _buildParticipantsList(),
        
        // 라운드 설정 버튼
        if (_participants.length >= 2) ...[
          const SizedBox(height: AppTheme.spacingM),
          AppButton(
            text: '라운드 설정',
            type: AppButtonType.primary,
            size: AppButtonSize.large,
            isFullWidth: true,
            icon: LucideIcons.trophy,
            onPressed: _proceedToRounds,
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyParticipants() {
    return AppCard(
      child: Column(
        children: [
          Icon(
            LucideIcons.users,
            size: 48,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            '참가자를 추가해주세요',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            '게임에 참여할 사람들을 추가하세요\n(최소 2명, 최대 10명)',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsList() {
    return Column(
      children: _participants
          .asMap()
          .entries
          .map((entry) => _buildParticipantCard(entry.key, entry.value))
          .toList(),
    );
  }

  Widget _buildParticipantCard(int index, Participant participant) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.secondary.withOpacity(0.1),
            child: Text(
              participant.name[0].toUpperCase(),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Text(
              participant.name,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _removeParticipant(index),
            icon: const Icon(
              LucideIcons.x,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }


  void _addParticipant() {
    showDialog(
      context: context,
      builder: (context) => _ParticipantDialog(
        onAdd: (name) {
          setState(() {
            _participants.add(Participant(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: name,
            ));
          });
        },
      ),
    );
  }

  void _removeParticipant(int index) {
    setState(() {
      _participants.removeAt(index);
    });
  }

  void _proceedToRounds() async {
    if (_participants.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최소 2명의 참가자가 필요합니다'),
        ),
      );
      return;
    }

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('게임 제목을 입력해주세요'),
        ),
      );
      return;
    }

    try {
      // 백엔드 API를 통한 게임 생성
      final participantIds = <String>[];
      
      // 1. 참가자들을 백엔드에 생성
      for (final participant in _participants) {
        // 참가자 이름 검증
        if (participant.name.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('참가자 이름을 입력해주세요.'),
            ),
          );
          return;
        }

        final response = await GameApiService.createParticipant(
          name: participant.name,
          avatar: participant.avatar,
        );
        
        if (response.isSuccess && response.data != null) {
          participantIds.add(response.data!.id);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('참가자 생성 실패: ${response.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      // 2. 게임 생성
      final gameResponse = await GameApiService.createGame(
        title: _titleController.text.trim(),
      );

      if (gameResponse.isSuccess && gameResponse.data != null) {
        final game = gameResponse.data!;
        
        // 3. 게임에 참가자들 추가
        for (final participantId in participantIds) {
          final addResponse = await GameApiService.addParticipantToGame(game.id, participantId);
          if (!addResponse.isSuccess) {
            print('참가자 추가 실패: ${addResponse.errorMessage}');
            // 참가자 추가 실패해도 게임은 생성되었으므로 계속 진행
          }
        }

        // 4. GameApi를 Game 모델로 변환하여 라운드 화면으로 이동
        final gameModel = Game(
          id: game.id,
          title: game.title,
          participants: _participants,
          rounds: [],
          status: GameStatus.inProgress,
          createdAt: game.createdAt ?? DateTime.now(),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GameRoundsScreen(game: gameModel),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('게임 생성 실패: ${gameResponse.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('게임 생성 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}

class _ParticipantDialog extends StatefulWidget {
  final Function(String) onAdd;

  const _ParticipantDialog({required this.onAdd});

  @override
  State<_ParticipantDialog> createState() => _ParticipantDialogState();
}

class _ParticipantDialogState extends State<_ParticipantDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('참가자 추가'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: '닉네임',
          hintText: '참가자 닉네임을 입력하세요',
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onAdd(_controller.text.trim());
              Navigator.of(context).pop();
            }
          },
          child: const Text('추가'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
