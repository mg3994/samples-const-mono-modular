import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';

import '../../../../../../../app/app.dart' show BuildContextLocalizationExtensions;
import '../../bloc/appearance_settings_bloc.dart';
import '../../bloc/appearance_settings_state.dart' show AppearanceSettingsState;

class AppearanceSettingsThemeModeWidget extends StatelessWidget {
  const AppearanceSettingsThemeModeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final bloc = context.read<AppearanceSettingsBloc>();

    return BlocSignalBuilder<AppearanceSettingsBloc, AppearanceSettingsState>(
      bloc: bloc,
      builder: (context, state) {
        final currentMode = state.themeMode;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.themeModeTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.themeModeSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  icon: const Icon(Icons.brightness_auto),
                  label: Text(l10n.themeModeSystem),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  icon: const Icon(Icons.light_mode),
                  label: Text(l10n.themeModeLight),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  icon: const Icon(Icons.dark_mode),
                  label: Text(l10n.themeModeDark),
                ),
              ],
              selected: {currentMode},
              onSelectionChanged: (selected) {
                if (selected.isNotEmpty) {
                  bloc.add(SetThemeModeEvent(selected.first));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
