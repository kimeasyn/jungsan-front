import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget? body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool showAppBar;
  final bool centerTitle;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  const AppScaffold({
    super.key,
    this.title,
    this.body,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.showAppBar = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: showAppBar
          ? AppBar(
              title: title != null
                  ? Text(
                      title!,
                      style: AppTypography.h3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    )
                  : null,
              centerTitle: centerTitle,
              actions: actions,
              bottom: bottom,
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              scrolledUnderElevation: 0,
            )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
    );
  }
}

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final List<AppBottomNavigationItem> items;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        selectedLabelStyle: AppTypography.captionMedium,
        unselectedLabelStyle: AppTypography.caption,
        items: items
            .map((item) => BottomNavigationBarItem(
                  icon: item.icon,
                  activeIcon: item.activeIcon ?? item.icon,
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }
}

class AppBottomNavigationItem {
  final Widget icon;
  final Widget? activeIcon;
  final String label;

  const AppBottomNavigationItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

class AppDrawer extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final List<AppDrawerItem> items;
  final VoidCallback? onProfileTap;

  const AppDrawer({
    super.key,
    this.userName,
    this.userEmail,
    required this.items,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: InkWell(
              onTap: onProfileTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.textOnPrimary,
                    child: Text(
                      userName?.isNotEmpty == true
                          ? userName![0].toUpperCase()
                          : 'U',
                      style: AppTypography.h2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userName ?? '사용자',
                    style: AppTypography.h4.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  if (userEmail != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      userEmail!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textOnPrimary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: AppColors.textSecondary,
                  ),
                  title: Text(
                    item.title,
                    style: AppTypography.body,
                  ),
                  onTap: item.onTap,
                  selected: item.isSelected,
                  selectedTileColor: AppColors.primary.withOpacity(0.1),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppDrawerItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isSelected;

  const AppDrawerItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.isSelected = false,
  });
}
