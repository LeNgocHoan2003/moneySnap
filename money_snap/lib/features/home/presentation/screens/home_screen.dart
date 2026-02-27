import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_snap/i18n/strings.g.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../features/expense/presentation/stores/expense_store.dart';
import '../../../../features/expense/presentation/screens/expense_list_screen.dart';
import '../../../../features/settings/presentation/screens/settings_screen.dart';

enum _HomeTab { expenses, settings }

/// Home screen with bottom tabs for expenses and settings.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.store,
  });

  final ExpenseStore store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeTab _selectedTab = _HomeTab.expenses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final navBgColor = isDark ? AppColors.darkSurface : colorScheme.surface;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.4)
        : AppColors.overlayLight;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              Assets.appLogo,
              height: 26,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Text(
              context.t.appTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_selectedTab == _HomeTab.expenses)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 20,
                      color: colorScheme.primary.withOpacity(0.9),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.t.homeUsageGuide,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withOpacity(
                            isDark ? 0.6 : 0.7,
                          ),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBgColor,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(
                  Icons.home_outlined,
                  Icons.home_rounded,
                  'Home',
                  _HomeTab.expenses,
                ),
                _navItem(
                  Icons.settings_outlined,
                  Icons.settings_rounded,
                  'Settings',
                  _HomeTab.settings,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _selectedTab == _HomeTab.expenses
          ? FloatingActionButton(
              onPressed: () => context.push(AppRoutes.add),
              elevation: isDark ? 4 : 2,
              child: const Icon(Icons.add_rounded),
            )
          : null,
    );
  }

  Widget _buildBody() {
    switch (_selectedTab) {
      case _HomeTab.expenses:
        return ExpenseListScreen(store: widget.store);
      case _HomeTab.settings:
        return const SettingsScreen();
    }
  }

  Widget _navItem(
    IconData outline,
    IconData filled,
    String label,
    _HomeTab tab,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = _selectedTab == tab;
    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.onSurfaceVariant.withOpacity(
      Theme.of(context).brightness == Brightness.dark ? 0.6 : 0.7,
    );

    return InkWell(
      onTap: () => setState(() => _selectedTab = tab),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? filled : outline,
              color: selected ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? activeColor : inactiveColor,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
