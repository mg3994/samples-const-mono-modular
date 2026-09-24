import 'package:flutter/material.dart';

/// Application router managing navigation for the Blogstore app.
final class const AppRouter({
  /// Optional application settings BLoC used for route configurations.
  final Object? appSettingBloc,
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
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to Blogstore!'),
        ),
      ),
    );
  }
}
