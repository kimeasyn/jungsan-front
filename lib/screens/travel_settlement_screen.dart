import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/layout/app_scaffold.dart';
import '../services/travel_api_service.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';

class TravelSettlementScreen extends StatefulWidget {
  const TravelSettlementScreen({super.key});

  @override
  State<TravelSettlementScreen> createState() => _TravelSettlementScreenState();
}

class _TravelSettlementScreenState extends State<TravelSettlementScreen> {
  final List<Map<String, dynamic>> _participants = [];
  final List<Map<String, dynamic>> _expenses = [];
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '여행 정산',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 여행 제목 입력
            _buildTitleSection(),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 참가자 섹션
            _buildParticipantsSection(),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 비용 입력 섹션
            _buildExpensesSection(),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 정산 버튼
            if (_participants.isNotEmpty && _expenses.isNotEmpty)
              _buildSettlementButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '여행 제목',
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: '여행 제목을 입력하세요',
            border: OutlineInputBorder(),
          ),
        ),
      ],
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
            '여행에 참여한 사람들을 추가하세요',
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
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              participant['name'][0].toUpperCase(),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
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

  Widget _buildExpensesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '비용 내역',
              style: AppTypography.h3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            AppButton(
              text: '비용 추가',
              type: AppButtonType.outline,
              size: AppButtonSize.small,
              icon: LucideIcons.plus,
              onPressed: _addExpense,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingM),
        if (_expenses.isEmpty)
          _buildEmptyExpenses()
        else
          _buildExpensesList(),
      ],
    );
  }

  Widget _buildEmptyExpenses() {
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
            '비용을 추가해주세요',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            '숙박, 교통, 식사 등 비용을 입력하세요',
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesList() {
    return Column(
      children: _expenses
          .asMap()
          .entries
          .map((entry) => _buildExpenseCard(entry.key, entry.value))
          .toList(),
    );
  }

  Widget _buildExpenseCard(int index, Map<String, dynamic> expense) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  expense['title'],
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _removeExpense(index),
                icon: const Icon(
                  LucideIcons.x,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  expense['category'],
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                '결제자: ${expense['payer']}',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            '${expense['amount'].toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            )}원',
            style: AppTypography.h4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementButton() {
    return AppButton(
      text: _isLoading ? '저장 중...' : '정산하기',
      type: AppButtonType.primary,
      size: AppButtonSize.large,
      isFullWidth: true,
      icon: LucideIcons.calculator,
      onPressed: _isLoading ? null : _calculateSettlement,
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

  void _addExpense() {
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
      builder: (context) => _ExpenseDialog(
        participants: _participants,
        onAdd: (expense) {
          setState(() {
            _expenses.add(expense);
          });
        },
      ),
    );
  }

  void _removeExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  void _calculateSettlement() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('여행 제목을 입력해주세요'),
        ),
      );
      return;
    }

    if (_participants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최소 1명의 참가자가 필요합니다'),
        ),
      );
      return;
    }

    if (_expenses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최소 1개의 비용을 입력해주세요'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 총 금액 계산
      final totalAmount = _expenses.fold<double>(
        0.0,
        (sum, expense) => sum + (expense['amount'] as double),
      );

      // 여행 정산 생성
      final response = await TravelApiService.createTravelSettlement(
        title: _titleController.text.trim(),
        totalAmount: totalAmount,
      );

      if (response.isSuccess && response.data != null) {
        final settlement = response.data!;
        
        // 비용들을 여행 정산에 추가
        for (final expense in _expenses) {
          await TravelApiService.createTravelExpense(
            settlement.id,
            participantId: 'temp-participant-id', // 실제로는 참가자 ID를 사용해야 함
            amount: expense['amount'] as double,
            description: expense['title'] as String,
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('여행 정산이 생성되었습니다'),
          ),
        );

        // 홈 화면으로 돌아가기
        Navigator.of(context).pop();
      } else {
        setState(() {
          _errorMessage = response.errorMessage ?? '여행 정산 생성에 실패했습니다';
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = '오류가 발생했습니다: $e';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          labelText: '이름',
          hintText: '참가자 이름을 입력하세요',
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

class _ExpenseDialog extends StatefulWidget {
  final List<Map<String, dynamic>> participants;
  final Function(Map<String, dynamic>) onAdd;

  const _ExpenseDialog({
    required this.participants,
    required this.onAdd,
  });

  @override
  State<_ExpenseDialog> createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<_ExpenseDialog> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();
  String _selectedCategory = '숙박';
  String _selectedPayer = '';

  final List<String> _categories = [
    '숙박',
    '교통',
    '식사',
    '관광',
    '쇼핑',
    '기타',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.participants.isNotEmpty) {
      _selectedPayer = widget.participants.first['name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('비용 추가'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                hintText: '예: 호텔 숙박비',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: '금액',
                hintText: '예: 100000',
                suffixText: '원',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: '카테고리',
              ),
              items: _categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPayer,
              decoration: const InputDecoration(
                labelText: '결제자',
              ),
              items: widget.participants
                  .map((participant) => DropdownMenuItem<String>(
                        value: participant['name'],
                        child: Text(participant['name']),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPayer = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _memoController,
              decoration: const InputDecoration(
                labelText: '메모 (선택사항)',
                hintText: '추가 설명을 입력하세요',
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _addExpense,
          child: const Text('추가'),
        ),
      ],
    );
  }

  void _addExpense() {
    if (_titleController.text.trim().isEmpty ||
        _amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('제목과 금액을 입력해주세요'),
        ),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('올바른 금액을 입력해주세요'),
        ),
      );
      return;
    }

    widget.onAdd({
      'title': _titleController.text.trim(),
      'amount': amount,
      'category': _selectedCategory,
      'payer': _selectedPayer,
      'memo': _memoController.text.trim(),
    });

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }
}
