import 'package:flutter/material.dart';

void main() {
  // Obtain the single global WidgetsBinding instance
  final binding = WidgetsFlutterBinding.ensureInitialized();
  binding.deferFirstFrame();
  // bootstrap then run app
}

