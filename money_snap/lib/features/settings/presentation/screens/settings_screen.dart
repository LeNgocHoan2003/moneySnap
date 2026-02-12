import 'package:flutter/material.dart';

import '../../../../core/locale/locale_controller.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../i18n/strings.g.dart';

// Shared layout constants for cards and tiles (Material 3–friendly).
const double _kCardRadius = 12;
const double _kSectionSpacing = 28;
const double _kHeaderToCardSpacing = 10;
const EdgeInsets _kListPadding = EdgeInsets.symmetric(
  horizontal: 20,
  vertical: 12,
);

/// Settings screen: appearance (dark mode) and language.
/// Uses [ThemeController] and [LocaleController]; theme and locale from context.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final t = context.t;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(t.homeSettings),
      // ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          _SectionHeader(
            icon: Icons.dark_mode_outlined,
            label: t.settingsAppearance,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: _kHeaderToCardSpacing),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.instance.themeMode,
            builder: (context, themeMode, _) {
              final isDark = themeMode == ThemeMode.dark;
              return _SettingsCard(
                colorScheme: colorScheme,
                theme: theme,
                child: SwitchListTile.adaptive(
                  contentPadding: _kListPadding,
                  secondary: Icon(
                    Icons.dark_mode_outlined,
                    color: colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  title: Text(
                    t.settingsDarkMode,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      t.settingsDarkModeSubtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  value: isDark,
                  onChanged: (value) {
                    ThemeController.instance.setDarkMode(value);
                  },
                ),
              );
            },
          ),
          const SizedBox(height: _kSectionSpacing),
          _SectionHeader(
            icon: Icons.language_rounded,
            label: t.settingsLanguage,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: _kHeaderToCardSpacing),
          _SettingsCard(
            colorScheme: colorScheme,
            theme: theme,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LanguageTile(
                  title: t.settingsLanguageEnglish,
                  subtitle: t.settingsLanguageSubtitle,
                  isSelected: LocaleController.instance.currentLocale == AppLocale.en,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  onTap: () async {
                    await LocaleController.instance.setLocale(AppLocale.en);
                    if (context.mounted) {}
                  },
                ),
                Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                ),
                _LanguageTile(
                  title: t.settingsLanguageVietnamese,
                  subtitle: t.settingsLanguageSubtitle,
                  isSelected: LocaleController.instance.currentLocale == AppLocale.vi,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  onTap: () async {
                    await LocaleController.instance.setLocale(AppLocale.vi);
                    if (context.mounted) {}
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section header with icon and label; uses theme only.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.textTheme,
  });

  final IconData icon;
  final String label;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Single card container for a settings block; theme-based only.
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.colorScheme,
    required this.theme,
    required this.child,
  });

  final ColorScheme colorScheme;
  final ThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorScheme.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_kCardRadius),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

/// One language option row with title, subtitle, and selection indicator.
class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: _kListPadding,
      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          subtitle,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle_rounded,
              color: colorScheme.primary,
              size: 24,
            )
          : null,
      onTap: onTap,
    );
  }
}
