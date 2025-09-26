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
import 'game_rounds_screen.dart';

class GameParticipantsScreen extends StatefulWidget {
  const GameParticipantsScreen({super.key});

  @override
  State<GameParticipantsScreen> createState() => _GameParticipantsScreenState();
}

class _GameParticipantsScreenState extends State<GameParticipantsScreen> {
  final List<Participant> _participants = [];
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = '새 게임';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '참가자 설정',
      actions: [
        if (_participants.length >= 2)
          TextButton(
            onPressed: _proceedToRounds,
            child: Text(
              '다음',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
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
            
            // 다음 버튼
            if (_participants.length >= 2) _buildNextButton(),
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

  Widget _buildNextButton() {
    return AppButton(
      text: '라운드 설정으로 이동',
      type: AppButtonType.primary,
      size: AppButtonSize.large,
      isFullWidth: true,
      icon: LucideIcons.arrowRight,
      onPressed: _proceedToRounds,
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

  void _proceedToRounds() {
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

    final game = Game(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      participants: _participants,
      rounds: [],
      status: GameStatus.inProgress,
      createdAt: DateTime.now(),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => GameRoundsScreen(game: game),
      ),
    );
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
