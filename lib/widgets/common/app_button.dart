import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

enum AppButtonType {
  primary,
  secondary,
  outline,
  text,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final buttonSize = _getButtonSize();
    final textStyle = _getTextStyle();

    Widget buttonChild = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getTextColor(context),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(text, style: textStyle),
      ],
    );

    switch (type) {
      case AppButtonType.primary:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          ),
        );
      case AppButtonType.secondary:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(
                backgroundColor ?? AppColors.secondary,
              ),
            ),
            child: buttonChild,
          ),
        );
      case AppButtonType.outline:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          ),
        );
      case AppButtonType.text:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          ),
        );
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final baseStyle = ElevatedButton.styleFrom(
      padding: _getButtonPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    switch (type) {
      case AppButtonType.primary:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(
            backgroundColor ?? AppColors.primary,
          ),
          foregroundColor: MaterialStateProperty.all(
            textColor ?? AppColors.textOnPrimary,
          ),
        );
      case AppButtonType.secondary:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(
            backgroundColor ?? AppColors.secondary,
          ),
          foregroundColor: MaterialStateProperty.all(
            textColor ?? AppColors.textPrimary,
          ),
        );
      case AppButtonType.outline:
        return OutlinedButton.styleFrom(
          padding: _getButtonPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: backgroundColor ?? AppColors.primary,
          ),
          foregroundColor: textColor ?? AppColors.primary,
        );
      case AppButtonType.text:
        return TextButton.styleFrom(
          padding: _getButtonPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          foregroundColor: textColor ?? AppColors.primary,
        );
    }
  }

  EdgeInsets _getButtonPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  AppButtonSize _getButtonSize() {
    return size;
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.buttonSmall;
      case AppButtonSize.medium:
        return AppTypography.button;
      case AppButtonSize.large:
        return AppTypography.buttonLarge;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (type) {
      case AppButtonType.primary:
        return textColor ?? AppColors.textOnPrimary;
      case AppButtonType.secondary:
        return textColor ?? AppColors.textPrimary;
      case AppButtonType.outline:
        return textColor ?? AppColors.primary;
      case AppButtonType.text:
        return textColor ?? AppColors.primary;
    }
  }
}
