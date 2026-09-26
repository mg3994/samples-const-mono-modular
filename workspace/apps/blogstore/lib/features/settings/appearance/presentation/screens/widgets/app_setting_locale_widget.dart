import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';

import '../../../../../../../app/app.dart' show BuildContextLocalizationExtensions;
import '../../bloc/appearance_settings_bloc.dart';
import '../../bloc/appearance_settings_state.dart' show AppearanceSettingsState;


class AppearanceSettingsLocaleWidget extends StatelessWidget {
  const AppearanceSettingsLocaleWidget({super.key});

  static const List<({Locale locale, String name})> _supportedLanguages = [
    (locale: Locale('en'), name: 'English'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final bloc = context.read<AppearanceSettingsBloc>();

    return BlocSignalBuilder<AppearanceSettingsBloc, AppearanceSettingsState>(
      bloc: bloc,
      builder: (context, state) {
        final currentLocale = state.locale;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.localeTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.localeSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ..._supportedLanguages.map((lang) {
              final isSelected =
                  currentLocale.languageCode == lang.locale.languageCode;

              return Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.secondaryContainer
                      : colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  leading: Icon(
                    Icons.language,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                  title: Text(
                    lang.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: colorScheme.primary)
                      : null,
                  onTap: () {
                    if (!isSelected) {
                      bloc.add(SetLocaleEvent(lang.locale));
                    }
                  },
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
