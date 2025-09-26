import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/layout/app_scaffold.dart';
import '../services/game_api_service.dart';
import '../services/travel_api_service.dart';
import '../models/api_models.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  List<String> _logs = [];
  bool _isLoading = false;

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  Future<void> _testParticipants() async {
    setState(() => _isLoading = true);
    _addLog('참가자 목록 조회 시작...');
    
    try {
      final response = await GameApiService.getParticipants();
      if (response.isSuccess) {
        _addLog('참가자 목록 조회 성공: ${response.data?.length}명');
      } else {
        _addLog('참가자 목록 조회 실패: ${response.errorMessage}');
      }
    } catch (e) {
      _addLog('참가자 목록 조회 오류: $e');
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _testCreateParticipant() async {
    setState(() => _isLoading = true);
    _addLog('참가자 생성 시작...');
    
    try {
      final response = await GameApiService.createParticipant(
        name: '테스트 참가자 ${DateTime.now().millisecondsSinceEpoch}',
      );
      if (response.isSuccess) {
        _addLog('참가자 생성 성공: ${response.data?.name}');
      } else {
        _addLog('참가자 생성 실패: ${response.errorMessage}');
      }
    } catch (e) {
      _addLog('참가자 생성 오류: $e');
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _testGames() async {
    setState(() => _isLoading = true);
    _addLog('게임 목록 조회 시작...');
    
    try {
      final response = await GameApiService.getGames();
      if (response.isSuccess) {
        _addLog('게임 목록 조회 성공: ${response.data?.length}개');
      } else {
        _addLog('게임 목록 조회 실패: ${response.errorMessage}');
      }
    } catch (e) {
      _addLog('게임 목록 조회 오류: $e');
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _testCreateGame() async {
    setState(() => _isLoading = true);
    _addLog('게임 생성 시작...');
    
    try {
      final response = await GameApiService.createGame(
        title: '테스트 게임 ${DateTime.now().millisecondsSinceEpoch}',
      );
      if (response.isSuccess) {
        _addLog('게임 생성 성공: ${response.data?.title}');
      } else {
        _addLog('게임 생성 실패: ${response.errorMessage}');
      }
    } catch (e) {
      _addLog('게임 생성 오류: $e');
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _testTravelSettlements() async {
    setState(() => _isLoading = true);
    _addLog('여행 정산 목록 조회 시작...');
    
    try {
      final response = await TravelApiService.getTravelSettlements();
      if (response.isSuccess) {
        _addLog('여행 정산 목록 조회 성공: ${response.data?.length}개');
      } else {
        _addLog('여행 정산 목록 조회 실패: ${response.errorMessage}');
      }
    } catch (e) {
      _addLog('여행 정산 목록 조회 오류: $e');
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'API 연결 테스트',
      actions: [
        IconButton(
          onPressed: _clearLogs,
          icon: const Icon(LucideIcons.trash2),
          tooltip: '로그 지우기',
        ),
      ],
      body: Column(
        children: [
          // 테스트 버튼들
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'API 테스트',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                Wrap(
                  spacing: AppTheme.spacingS,
                  runSpacing: AppTheme.spacingS,
                  children: [
                    AppButton(
                      text: '참가자 목록',
                      type: AppButtonType.outline,
                      size: AppButtonSize.small,
                      onPressed: _isLoading ? null : _testParticipants,
                    ),
                    AppButton(
                      text: '참가자 생성',
                      type: AppButtonType.outline,
                      size: AppButtonSize.small,
                      onPressed: _isLoading ? null : _testCreateParticipant,
                    ),
                    AppButton(
                      text: '게임 목록',
                      type: AppButtonType.outline,
                      size: AppButtonSize.small,
                      onPressed: _isLoading ? null : _testGames,
                    ),
                    AppButton(
                      text: '게임 생성',
                      type: AppButtonType.outline,
                      size: AppButtonSize.small,
                      onPressed: _isLoading ? null : _testCreateGame,
                    ),
                    AppButton(
                      text: '여행 정산 목록',
                      type: AppButtonType.outline,
                      size: AppButtonSize.small,
                      onPressed: _isLoading ? null : _testTravelSettlements,
                    ),
                  ],
                ),
                if (_isLoading) ...[
                  const SizedBox(height: AppTheme.spacingM),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // 로그 표시
          Expanded(
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '테스트 로그',
                        style: AppTypography.h4.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${_logs.length}개',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppTheme.spacingS),
                      decoration: BoxDecoration(
                        color: AppColors.neutralLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: _logs.isEmpty
                          ? Center(
                              child: Text(
                                '테스트를 실행하면 로그가 여기에 표시됩니다.',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _logs.length,
                              itemBuilder: (context, index) {
                                final log = _logs[index];
                                final isError = log.contains('실패') || log.contains('오류');
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    log,
                                    style: AppTypography.small.copyWith(
                                      color: isError 
                                          ? AppColors.error 
                                          : AppColors.textSecondary,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
