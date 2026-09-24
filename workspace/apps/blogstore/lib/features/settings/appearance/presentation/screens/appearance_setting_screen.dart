import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';

import '../../../../../app/app.dart' show BuildContextLocalizationExtensions;

class AppearanceSettingScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final isCompact = mq.size.width < 700;
    final isOnlyPage = KaiselPageScope.maybeOf(context)?.isBottom ?? false;
    // On wide screens, master & detail are visible side-by-side: disable the back button
    final showBackButton = isCompact && !isOnlyPage;
    return BlocSignalProvider<AppSettingBloc>.value(
      value: context.dependencies.appSettingBloc,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          title: Text(context.l10n.settingsAppearanceTitle),
          automaticallyImplyLeading: showBackButton, // here still one issue is there if one person is on wide dispalay and he clicks multiple times on any of the option of setting master then that option be in stack multiple times , and as we resize it to compact this will cause issue as we have to click multple time to go back , and in most of cases the route will be the same we are poping
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isCompact) ...[
                  Text(
                    context.l10n.settingsAppearanceTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                const AppSettingThemeModeWidget(),
                const SizedBox(height: 32),
                const AppSettingSeedColorWidget(),
                const SizedBox(height: 32),
                const AppSettingLocaleWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
