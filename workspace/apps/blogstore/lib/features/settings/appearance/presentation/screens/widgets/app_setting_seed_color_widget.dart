import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';

import '../../../../../../../app/app.dart' show BuildContextLocalizationExtensions;
import '../../bloc/appearance_settings_bloc.dart';
import '../../bloc/appearance_settings_state.dart' show AppearanceSettingsState;

class AppearanceSettingsSeedColorWidget extends StatelessWidget {
  const AppearanceSettingsSeedColorWidget({super.key});

  static const List<Color> _presetColors = [
    Color(0xFFFF9800), // Orange (Default)
    Color(0xFF6750A4), // Deep Purple
    Color(0xFF2196F3), // Blue
    Color(0xFF009688), // Teal
    Color(0xFF4CAF50), // Green
    Color(0xFFFF5722), // Deep Orange
    Color(0xFFE91E63), // Pink
    Color(0xFFFFC107), // Amber
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
        final currentColor = state.seedColor;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.seedColorTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.seedColorSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _presetColors.map((color) {
                final isSelected = currentColor.toARGB32() == color.toARGB32();

                return InkWell(
                  onTap: () {
                    if (!isSelected) {
                      bloc.add(SetSeedColorEvent(color));
                    }
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.onSurface
                            : Colors.transparent,
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.35),
                          blurRadius: isSelected ? 8 : 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
