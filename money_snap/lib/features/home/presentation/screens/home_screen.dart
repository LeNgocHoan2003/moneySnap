import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_snap/i18n/strings.g.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../features/expense/presentation/stores/expense_store.dart';
import '../../../../features/expense/presentation/screens/expense_list_screen.dart';
import '../../../../features/settings/presentation/screens/settings_screen.dart';

/// Tabs for the home screen.
enum _HomeTab { expenses, settings }

/// Home screen with bottom tabs for expenses and settings.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.store,
  });

  /// Shared expense store instance.
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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(Assets.appLogo, height: 36, fit: BoxFit.contain),
            const SizedBox(width: 8),
            Text(context.t.appTitle, style: theme.textTheme.titleLarge),
          ],
        )

      ),
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.overlayLight,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(
                  Icons.home_outlined,
                  Icons.home,
                  'Home',
                  _HomeTab.expenses,
                ),
                _navItem(
                  Icons.settings_outlined,
                  Icons.settings,
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
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              child: const Icon(Icons.add),
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
    return InkWell(
      onTap: () => setState(() => _selectedTab = tab),
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Icon(
            selected ? filled : outline,
            color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

