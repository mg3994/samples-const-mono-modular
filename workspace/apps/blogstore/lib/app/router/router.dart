import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart' show KaiselConfig, KaiselConfigCodec, KaiselModalRoute, KaiselRoute, KaiselShellConfig;
part 'routes.dart';
part 'app_stack_codec.dart';

/// Application router managing navigation for the Blogstore app.
final class const AppRouter({
  /// Optional application settings BLoC used for route configurations.
  final Object? appearenceSettingBloc,
}) {
  /// Builds the top-level application widget with navigation.
  Widget buildApp(BuildContext context) {
    return MaterialApp(
      title: 'Blogstore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('Welcome to Blogstore!'))),
    );
  }
}
