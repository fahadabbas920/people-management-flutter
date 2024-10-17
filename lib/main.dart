import 'package:flutter/material.dart';
import 'package:myapp/add_person_screen.dart';
import 'package:myapp/person.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'global_state.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (_) => GlobalState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the routes using GoRouter
    final GoRouter router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen(); // Initial route
          },
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen(); // Explicit route for login
          },
        ),
        GoRoute(
          path: '/dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const DashboardScreen(); // Explicit route for dashboard
          },
        ),
        GoRoute(
          path: '/add-person',
          builder: (context, state) {
            final extra = state.extra
                as Map<String, dynamic>?; // Receive the extra argument
            return AddPersonScreen(
              onSave:
                  extra?['onSave'] as Function(Person), // Pass onSave function
            );
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Person App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: router, // Use the GoRouter configuration
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context, listen: true);

    return FutureBuilder<bool>(
      future: _loadUserStatus(globalState),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          if (snapshot.hasData && snapshot.data == true) {
            Future.microtask(() => context.go('/dashboard'));
          } else {
            Future.microtask(() => context.go('/login'));
          }
          return const SizedBox(); // Return an empty widget while navigating
        }
      },
    );
  }

  Future<bool> _loadUserStatus(GlobalState globalState) async {
    return globalState.email != null && globalState.token != null;
  }
}
