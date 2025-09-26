import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/layout/app_scaffold.dart';
import '../models/game_models.dart';
import '../services/settlement_calculator.dart';
import '../services/local_storage_service.dart';
import '../services/game_api_service.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';
import 'game_settlement_result_screen.dart';
import 'game_participants_screen.dart';

class GameRoundsScreen extends StatefulWidget {
  final Game game;

  const GameRoundsScreen({
    super.key,
    required this.game,
  });

  @override
  State<GameRoundsScreen> createState() => _GameRoundsScreenState();
}

class _GameRoundsScreenState extends State<GameRoundsScreen> {
  late Game _currentGame;

  @override
  void initState() {
    super.initState();
    _currentGame = widget.game;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 참가자 설정 화면으로 이동
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => GameParticipantsScreen(
              game: _currentGame,
            ),
          ),
        );
        return false;
      },
      child: AppScaffold(
        title: '${_currentGame.title} 관리',
        actions: [
          if (_currentGame.rounds.isNotEmpty)
            IconButton(
              onPressed: _showSettlementResult,
              icon: const Icon(LucideIcons.calculator),
              tooltip: '정산 결과 보기',
            ),
        ],
        body: Column(
          children: [
            // 게임 정보
            _buildGameInfo(),
            
            // 라운드 목록
            Expanded(
              child: _buildRoundsList(),
            ),
            
            // 하단 버튼들
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameInfo() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            '참가자',
            '${_currentGame.participants.length}명',
            LucideIcons.users,
            AppColors.secondary,
          ),
          _buildInfoItem(
            '라운드',
            '${_currentGame.rounds.length}개',
            LucideIcons.trophy,
            AppColors.primary,
          ),
          _buildInfoItem(
            '총 금액',
            '${_currentGame.totalAmount.toStringAsFixed(0).replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            )}원',
            LucideIcons.dollarSign,
            AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRoundsList() {
    if (_currentGame.rounds.isEmpty) {
      return _buildEmptyRounds();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: _currentGame.rounds.length,
      itemBuilder: (context, index) {
        final round = _currentGame.rounds[index];
        return _buildRoundCard(index, round);
      },
    );
  }

  Widget _buildEmptyRounds() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.trophy,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              '아직 라운드가 없습니다',
              style: AppTypography.h4.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              '라운드 추가 버튼을 눌러\n첫 번째 라운드를 시작해보세요!',
              style: AppTypography.body.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundCard(int index, GameRound round) {
    final winnerName = round.getWinnerName(_currentGame.participants);
    final totalAmount = round.totalAmount;

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${round.roundNumber}라운드',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _editRound(index),
                    icon: const Icon(
                      LucideIcons.edit,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _deleteRound(index),
                    icon: const Icon(
                      LucideIcons.trash2,
                      size: 18,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Row(
            children: [
              Icon(
                LucideIcons.crown,
                size: 16,
                color: AppColors.warning,
              ),
              const SizedBox(width: 4),
              Text(
                '승자: $winnerName',
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Row(
            children: [
              Icon(
                LucideIcons.dollarSign,
                size: 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: 4),
              Text(
                '총 지급: ${totalAmount.toStringAsFixed(0).replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                )}원',
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          if (round.payments.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingS),
            ...round.payments.map((payment) => _buildPaymentItem(payment)).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentItem(Payment payment) {
    final payerName = payment.getPayerName(_currentGame.participants);
    
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neutralLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            payerName,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            '${payment.amount.toStringAsFixed(0)}원',
            style: AppTypography.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        children: [
          AppButton(
            text: '라운드 추가',
            type: AppButtonType.primary,
            size: AppButtonSize.large,
            isFullWidth: true,
            icon: LucideIcons.plus,
            onPressed: _addRound,
          ),
          if (_currentGame.rounds.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: '정산 결과',
                    type: AppButtonType.outline,
                    size: AppButtonSize.medium,
                    icon: LucideIcons.calculator,
                    onPressed: _showSettlementResult,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: AppButton(
                    text: '게임 종료',
                    type: AppButtonType.outline,
                    size: AppButtonSize.medium,
                    icon: LucideIcons.flag,
                    onPressed: _completeGame,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _addRound() {
    _showRoundDialog();
  }

  void _editRound(int index) {
    _showRoundDialog(roundIndex: index);
  }

  void _deleteRound(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('라운드 삭제'),
        content: const Text('이 라운드를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final newRounds = List<GameRound>.from(_currentGame.rounds);
                newRounds.removeAt(index);
                _currentGame = _currentGame.copyWith(rounds: newRounds);
              });
              Navigator.of(context).pop();
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _showRoundDialog({int? roundIndex}) async {
    final result = await showDialog<GameRound?>(
      context: context,
      builder: (context) => _RoundDialog(
        participants: _currentGame.participants,
        roundNumber: roundIndex != null 
            ? _currentGame.rounds[roundIndex].roundNumber 
            : _currentGame.rounds.length + 1,
        initialRound: roundIndex != null ? _currentGame.rounds[roundIndex] : null,
      ),
    );

    if (result != null) {
      setState(() {
        final newRounds = List<GameRound>.from(_currentGame.rounds);
        if (roundIndex != null) {
          newRounds[roundIndex] = result;
        } else {
          newRounds.add(result);
        }
        _currentGame = _currentGame.copyWith(rounds: newRounds);
      });
    }
  }

  void _showSettlementResult() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameSettlementResultScreen(game: _currentGame),
      ),
    );
  }

  void _completeGame() async {
    setState(() {
      _currentGame = _currentGame.copyWith(
        status: GameStatus.completed,
        completedAt: DateTime.now(),
      );
    });

    // 게임 완료 시 로컬과 백엔드에 저장
    await _saveCompletedGame();

    Navigator.of(context).pop(_currentGame);
  }

  Future<void> _saveCompletedGame() async {
    try {
      // 백엔드 API에 게임 완료 상태 저장
      if (!_currentGame.id.startsWith('temp-')) {
        // 실제 백엔드 게임인 경우
        try {
          await GameApiService.updateGame(
            _currentGame.id,
            title: _currentGame.title,
            status: GameStatusApi.completed,
          );
          print('게임 완료 상태가 백엔드 DB에 저장되었습니다');
        } catch (e) {
          print('백엔드 저장 실패: $e');
          // 백엔드 저장 실패 시에도 로컬에 백업 저장
          await LocalStorageService.saveCompletedGame(_currentGame);
          print('백엔드 저장 실패로 로컬에 백업 저장됨');
        }
      } else {
        // 로컬 모드로 생성된 게임인 경우 - 백엔드에 새로 생성
        try {
          // 1. 게임 생성
          final gameResponse = await GameApiService.createGame(
            title: _currentGame.title,
          );
          
          if (gameResponse.isSuccess && gameResponse.data != null) {
            final newGameId = gameResponse.data!.id;
            
            // 2. 참가자들을 백엔드에 생성하고 게임에 추가
            for (final participant in _currentGame.participants) {
              try {
                final participantResponse = await GameApiService.createParticipant(
                  name: participant.name,
                  avatar: participant.avatar,
                );
                
                if (participantResponse.isSuccess && participantResponse.data != null) {
                  await GameApiService.addParticipantToGame(
                    newGameId, 
                    participantResponse.data!.id,
                  );
                }
              } catch (e) {
                print('참가자 생성 실패: $e');
              }
            }
            
            // 3. 라운드와 지급 내역을 백엔드에 저장
            for (final round in _currentGame.rounds) {
              try {
                final roundResponse = await GameApiService.createRound(
                  newGameId,
                  roundNumber: round.roundNumber,
                  winnerId: round.winnerId,
                );
                
                if (roundResponse.isSuccess && roundResponse.data != null) {
                  final roundId = roundResponse.data!.id;
                  
                  // 지급 내역 저장
                  for (final payment in round.payments) {
                    try {
                      await GameApiService.createPayment(
                        roundId,
                        payerId: payment.payerId,
                        recipientId: payment.recipientId,
                        amount: payment.amount,
                        memo: payment.memo,
                      );
                    } catch (e) {
                      print('지급 내역 생성 실패: $e');
                    }
                  }
                }
              } catch (e) {
                print('라운드 생성 실패: $e');
              }
            }
            
            // 4. 게임 완료 상태로 업데이트
            await GameApiService.updateGame(
              newGameId,
              title: _currentGame.title,
              status: GameStatusApi.completed,
            );
            
            print('로컬 게임이 백엔드 DB에 성공적으로 저장되었습니다');
          } else {
            throw Exception('게임 생성 실패: ${gameResponse.errorMessage}');
          }
        } catch (e) {
          print('백엔드 저장 실패, 로컬에 백업 저장: $e');
          await LocalStorageService.saveCompletedGame(_currentGame);
        }
      }
    } catch (e) {
      print('게임 완료 저장 실패: $e');
      // 최종적으로 로컬에라도 저장
      try {
        await LocalStorageService.saveCompletedGame(_currentGame);
        print('로컬에 백업 저장됨');
      } catch (localError) {
        print('로컬 저장도 실패: $localError');
      }
    }
  }
}

class _RoundDialog extends StatefulWidget {
  final List<Participant> participants;
  final int roundNumber;
  final GameRound? initialRound;

  const _RoundDialog({
    required this.participants,
    required this.roundNumber,
    this.initialRound,
  });

  @override
  State<_RoundDialog> createState() => _RoundDialogState();
}

class _RoundDialogState extends State<_RoundDialog> {
  String? _selectedWinnerId;
  final Map<String, TextEditingController> _amountControllers = {};
  final Map<String, TextEditingController> _memoControllers = {};

  @override
  void initState() {
    super.initState();
    
    // 초기화
    for (final participant in widget.participants) {
      _amountControllers[participant.id] = TextEditingController();
      _memoControllers[participant.id] = TextEditingController();
    }

    // 편집 모드인 경우 기존 데이터 로드
    if (widget.initialRound != null) {
      _selectedWinnerId = widget.initialRound!.winnerId;
      for (final payment in widget.initialRound!.payments) {
        _amountControllers[payment.payerId]?.text = payment.amount.toString();
        _memoControllers[payment.payerId]?.text = payment.memo ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.roundNumber}라운드 관리'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 승자 선택
              DropdownButtonFormField<String>(
                value: _selectedWinnerId,
                decoration: const InputDecoration(
                  labelText: '승자 선택',
                ),
                items: widget.participants
                    .map((participant) => DropdownMenuItem(
                          value: participant.id,
                          child: Text(participant.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedWinnerId = value;
                    // 승자가 변경되면 기존 입력값 초기화
                    if (value != null) {
                      for (final participant in widget.participants) {
                        if (participant.id != value) {
                          _amountControllers[participant.id]?.clear();
                          _memoControllers[participant.id]?.clear();
                        }
                      }
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // 지급 내역
              Text(
                '지급 내역',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...widget.participants.map((participant) {
                final isWinner = participant.id == _selectedWinnerId;
                return _buildPaymentField(participant, isWinner);
              }).toList(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _saveRound,
          child: const Text('저장'),
        ),
      ],
    );
  }

  Widget _buildPaymentField(Participant participant, bool isWinner) {
    final isWinnerSelected = _selectedWinnerId != null;
    final isDisabled = !isWinnerSelected && !isWinner;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isWinner 
            ? AppColors.warning.withOpacity(0.1) 
            : isDisabled 
                ? AppColors.neutralLight.withOpacity(0.5)
                : AppColors.neutralLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isWinner 
              ? AppColors.warning 
              : isDisabled 
                  ? AppColors.border.withOpacity(0.5)
                  : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                participant.name,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDisabled 
                      ? AppColors.textTertiary 
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isWinner) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '승자',
                    style: AppTypography.small.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (!isWinner) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _amountControllers[participant.id],
              enabled: isWinnerSelected,
              decoration: InputDecoration(
                labelText: '지급 금액',
                hintText: isWinnerSelected ? '0' : '승자를 먼저 선택하세요',
                suffixText: '원',
                hintStyle: TextStyle(
                  color: AppColors.textTertiary,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _memoControllers[participant.id],
              enabled: isWinnerSelected,
              decoration: InputDecoration(
                labelText: '메모 (선택사항)',
                hintText: isWinnerSelected ? '메모를 입력하세요' : '승자를 먼저 선택하세요',
                hintStyle: TextStyle(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _saveRound() {
    if (_selectedWinnerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('승자를 선택해주세요')),
      );
      return;
    }

    final payments = <Payment>[];
    bool hasPositivePayment = false;

    for (final participant in widget.participants) {
      if (participant.id == _selectedWinnerId) continue;

      final amountText = _amountControllers[participant.id]?.text.trim() ?? '';
      if (amountText.isNotEmpty) {
        final amount = double.tryParse(amountText) ?? 0;
        if (amount > 0) {
          hasPositivePayment = true;
          payments.add(Payment(
            id: DateTime.now().millisecondsSinceEpoch.toString() + participant.id,
            payerId: participant.id,
            recipientId: _selectedWinnerId!,
            amount: amount,
            memo: _memoControllers[participant.id]?.text.trim(),
          ));
        }
      }
    }

    if (!hasPositivePayment) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최소 하나의 양수 지급이 필요합니다')),
      );
      return;
    }

    final round = GameRound(
      id: widget.initialRound?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      roundNumber: widget.roundNumber,
      winnerId: _selectedWinnerId!,
      payments: payments,
      createdAt: widget.initialRound?.createdAt ?? DateTime.now(),
    );

    Navigator.of(context).pop(round);
  }

  @override
  void dispose() {
    for (final controller in _amountControllers.values) {
      controller.dispose();
    }
    for (final controller in _memoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
