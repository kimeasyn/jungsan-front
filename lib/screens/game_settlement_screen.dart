import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/layout/app_scaffold.dart';

class GameSettlementScreen extends StatefulWidget {
  const GameSettlementScreen({super.key});

  @override
  State<GameSettlementScreen> createState() => _GameSettlementScreenState();
}

class _GameSettlementScreenState extends State<GameSettlementScreen> {
  final List<Map<String, dynamic>> _participants = [];
  final List<Map<String, dynamic>> _rounds = [];
  double _stakeAmount = 1000; // 판당 금액

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '게임 정산',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 참가자 섹션
            _buildParticipantsSection(),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 판별 금액 설정
            _buildStakeAmountSection(),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 판별 결과 섹션
            _buildRoundsSection(),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 정산 버튼
            if (_participants.isNotEmpty && _rounds.isNotEmpty)
              _buildSettlementButton(),
          ],
        ),
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
              '참가자',
              style: AppTypography.h3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            AppButton(
              text: '참가자 추가',
              type: AppButtonType.outline,
              size: AppButtonSize.small,
              icon: LucideIcons.plus,
              onPressed: _addParticipant,
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
            '게임에 참여한 사람들을 추가하세요',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
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

  Widget _buildParticipantCard(int index, Map<String, dynamic> participant) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.secondary.withOpacity(0.1),
            child: Text(
              participant['name'][0].toUpperCase(),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Text(
              participant['name'],
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

  Widget _buildStakeAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '판별 금액 설정',
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '판별당 금액',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              TextField(
                initialValue: _stakeAmount.toString(),
                decoration: const InputDecoration(
                  hintText: '판별당 금액을 입력하세요',
                  suffixText: '원',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final amount = double.tryParse(value);
                  if (amount != null && amount > 0) {
                    setState(() {
                      _stakeAmount = amount;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoundsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '판별 결과',
              style: AppTypography.h3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            AppButton(
              text: '판 추가',
              type: AppButtonType.outline,
              size: AppButtonSize.small,
              icon: LucideIcons.plus,
              onPressed: _addRound,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingM),
        if (_rounds.isEmpty)
          _buildEmptyRounds()
        else
          _buildRoundsList(),
      ],
    );
  }

  Widget _buildEmptyRounds() {
    return AppCard(
      child: Column(
        children: [
          Icon(
            LucideIcons.trophy,
            size: 48,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            '판별 결과를 추가해주세요',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            '각 판의 승부 결과를 입력하세요',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundsList() {
    return Column(
      children: _rounds
          .asMap()
          .entries
          .map((entry) => _buildRoundCard(entry.key, entry.value))
          .toList(),
    );
  }

  Widget _buildRoundCard(int index, Map<String, dynamic> round) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${round['roundNumber']}판',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () => _removeRound(index),
                icon: const Icon(
                  LucideIcons.x,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          _buildRoundResults(round['results']),
        ],
      ),
    );
  }

  Widget _buildRoundResults(Map<String, double> results) {
    return Column(
      children: results.entries.map((entry) {
        final participant = _participants.firstWhere(
          (p) => p['name'] == entry.key,
          orElse: () => {'name': entry.key},
        );
        final score = entry.value;
        final isWinner = score > 0;
        
        return Container(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingXS),
          padding: const EdgeInsets.all(AppTheme.spacingS),
          decoration: BoxDecoration(
            color: isWinner 
                ? AppColors.accent.withOpacity(0.1)
                : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                participant['name'],
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${score > 0 ? '+' : ''}${score.toStringAsFixed(0)}점',
                style: AppTypography.bodyMedium.copyWith(
                  color: isWinner ? AppColors.accent : AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSettlementButton() {
    return AppButton(
      text: '정산하기',
      type: AppButtonType.primary,
      size: AppButtonSize.large,
      isFullWidth: true,
      icon: LucideIcons.calculator,
      onPressed: _calculateSettlement,
    );
  }

  void _addParticipant() {
    showDialog(
      context: context,
      builder: (context) => _ParticipantDialog(
        onAdd: (name) {
          setState(() {
            _participants.add({
              'name': name,
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
            });
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

  void _addRound() {
    if (_participants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('먼저 참가자를 추가해주세요'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _RoundDialog(
        participants: _participants,
        onAdd: (round) {
          setState(() {
            _rounds.add(round);
          });
        },
      ),
    );
  }

  void _removeRound(int index) {
    setState(() {
      _rounds.removeAt(index);
    });
  }

  void _calculateSettlement() {
    // TODO: 정산 계산 로직 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('정산 계산 기능은 곧 구현됩니다'),
      ),
    );
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

class _RoundDialog extends StatefulWidget {
  final List<Map<String, dynamic>> participants;
  final Function(Map<String, dynamic>) onAdd;

  const _RoundDialog({
    required this.participants,
    required this.onAdd,
  });

  @override
  State<_RoundDialog> createState() => _RoundDialogState();
}

class _RoundDialogState extends State<_RoundDialog> {
  final Map<String, TextEditingController> _scoreControllers = {};

  @override
  void initState() {
    super.initState();
    for (final participant in widget.participants) {
      _scoreControllers[participant['name']] = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('판별 결과 입력'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.participants.map((participant) {
            final name = participant['name'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: _scoreControllers[name],
                decoration: InputDecoration(
                  labelText: name,
                  hintText: '점수 입력 (예: 10, -5)',
                  suffixText: '점',
                ),
                keyboardType: TextInputType.number,
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _addRound,
          child: const Text('추가'),
        ),
      ],
    );
  }

  void _addRound() {
    final results = <String, double>{};
    bool hasValidScore = false;

    for (final participant in widget.participants) {
      final name = participant['name'];
      final scoreText = _scoreControllers[name]!.text.trim();
      
      if (scoreText.isNotEmpty) {
        final score = double.tryParse(scoreText);
        if (score != null) {
          results[name] = score;
          hasValidScore = true;
        }
      }
    }

    if (!hasValidScore) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최소 하나의 점수를 입력해주세요'),
        ),
      );
      return;
    }

    widget.onAdd({
      'roundNumber': widget.participants.length + 1,
      'results': results,
    });

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    for (final controller in _scoreControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
