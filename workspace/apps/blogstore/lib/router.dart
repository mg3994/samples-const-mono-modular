import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';

/// Define the routes for the application.
abstract class AppRoute extends KaiselRoute {
  const AppRoute();
}

class LoginRoute extends AppRoute {
  const LoginRoute();
}

class HomeRoute extends AppRoute {
  const HomeRoute();
}

/// A simulated authentication state container/bloc for router gating.
class AuthStateContainer {
  final bool isLoggedIn;
  AuthStateContainer({required this.isLoggedIn});

  ValueNotifier<AuthStateContainer> toValueListenable() {
    return ValueNotifier<AuthStateContainer>(this);
  }
}

/// Router orchestration following the Clean Architecture + Iceberg Pattern.
class AppRouter {
  final AuthStateContainer authContainer;

  AppRouter({required this.authContainer});

  KaiselRouterConfig createRouterConfig() {
    // Permanent Reflex: Dynamically compute the initial route using the container's current state value
    final AppRoute initialRoute = authContainer.isLoggedIn 
        ? const HomeRoute() 
        : const LoginRoute();

    return KaiselRouterConfig(
      initial: initialRoute,
      listenable: authContainer.toValueListenable(),
      guards: [
        (currentStack, proposedStack) {
          final isLoggedIn = authContainer.isLoggedIn;

          // Permanent Reflex: Implement an idempotent self-bypass to prevent infinite redirect recursion loops
          if (!isLoggedIn) {
            if (proposedStack.length == 1 && proposedStack.first is LoginRoute) {
              return proposedStack; // Allow access to LoginRoute without looping
            }
            return [const LoginRoute()];
          }

          // If logged in and trying to go to login page, redirect to home
          if (isLoggedIn && proposedStack.isNotEmpty && proposedStack.first is LoginRoute) {
            return [const HomeRoute()];
          }

          return proposedStack;
        },
      ], builder: (BuildContext context, KaiselRoute currentRoute) {
        return switch (currentRoute) {

          LoginRoute() => throw UnimplementedError(),
          HomeRoute() => throw UnimplementedError(),

          _ => throw UnimplementedError(),
        }
    },
    );
  }
}
