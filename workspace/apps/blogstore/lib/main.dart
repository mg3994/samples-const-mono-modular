import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';
import 'router.dart';

void main() {
  // Obtain the single global WidgetsBinding instance
  final binding = WidgetsFlutterBinding.ensureInitialized()
    ..deferFirstFrame();


  // Bootstrap containers (Clean Architecture + Iceberg Pattern)
  final authContainer = AuthStateContainer(isLoggedIn: false);
  final appRouter = AppRouter(authContainer: authContainer);
  final routerConfig = appRouter.createRouterConfig();

  binding.allowFirstFrame();

  runApp(BlogstoreApp(routerConfig: routerConfig));
}

class BlogstoreApp extends StatelessWidget {
  final KaiselRouterConfig routerConfig;

  const BlogstoreApp({super.key, required this.routerConfig});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Blogstore',
      home: KaiselRouter(
        config: routerConfig,
        builder: (context, currentRoute) {
          if (currentRoute is LoginRoute) {
            return const Scaffold(
              body: Center(child: Text('Login Screen')),
            );
          }
          return const Scaffold(
            body: Center(child: Text('Home Screen')),
          );
        },
      ),
    );
  }
}
