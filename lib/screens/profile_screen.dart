import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_theme.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_card.dart';
import '../widgets/layout/app_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '프로필',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          children: [
            // 프로필 정보 섹션
            _buildProfileSection(),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 통계 섹션
            _buildStatsSection(),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 설정 섹션
            _buildSettingsSection(context),
            const SizedBox(height: AppTheme.spacingXL),
            
            // 앱 정보 섹션
            _buildAppInfoSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return AppCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              'U',
              style: AppTypography.h1.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            '사용자',
            style: AppTypography.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'user@example.com',
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          AppButton(
            text: '프로필 편집',
            type: AppButtonType.outline,
            size: AppButtonSize.small,
            icon: LucideIcons.edit,
            onPressed: () {
              // TODO: 프로필 편집 기능 구현
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '정산 통계',
            style: AppTypography.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '총 정산',
                  '12회',
                  LucideIcons.receipt,
                  AppColors.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '여행 정산',
                  '8회',
                  LucideIcons.mapPin,
                  AppColors.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '게임 정산',
                  '4회',
                  LucideIcons.gamepad2,
                  AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '총 금액',
                  '2,450,000원',
                  LucideIcons.dollarSign,
                  AppColors.accent,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '평균 금액',
                  '204,167원',
                  LucideIcons.trendingUp,
                  AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: color,
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingXS),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '설정',
            style: AppTypography.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          _buildSettingItem(
            icon: LucideIcons.bell,
            title: '알림 설정',
            subtitle: '푸시 알림 및 이메일 알림',
            onTap: () {
              // TODO: 알림 설정 기능 구현
            },
          ),
          _buildSettingItem(
            icon: LucideIcons.palette,
            title: '테마 설정',
            subtitle: '다크 모드 및 색상 설정',
            onTap: () {
              // TODO: 테마 설정 기능 구현
            },
          ),
          _buildSettingItem(
            icon: LucideIcons.language,
            title: '언어 설정',
            subtitle: '한국어',
            onTap: () {
              // TODO: 언어 설정 기능 구현
            },
          ),
          _buildSettingItem(
            icon: LucideIcons.shield,
            title: '개인정보 보호',
            subtitle: '데이터 관리 및 보안 설정',
            onTap: () {
              // TODO: 개인정보 보호 기능 구현
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '앱 정보',
            style: AppTypography.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          _buildInfoItem(
            '앱 버전',
            '1.0.0',
          ),
          _buildInfoItem(
            '빌드 번호',
            '1',
          ),
          _buildInfoItem(
            '업데이트',
            '2024-01-15',
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: '도움말',
                  type: AppButtonType.outline,
                  size: AppButtonSize.small,
                  icon: LucideIcons.helpCircle,
                  onPressed: () {
                    // TODO: 도움말 기능 구현
                  },
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: AppButton(
                  text: '피드백',
                  type: AppButtonType.outline,
                  size: AppButtonSize.small,
                  icon: LucideIcons.messageCircle,
                  onPressed: () {
                    // TODO: 피드백 기능 구현
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTypography.body.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
