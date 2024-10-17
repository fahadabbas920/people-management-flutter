import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'global_state.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
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
    return MaterialApp(
      title: 'Person App',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Define routes here
      routes: {
        '/': (context) => const HomeScreen(), // Initial route
        '/login': (context) => const LoginScreen(), // Explicit route for login
        '/dashboard': (context) =>
            const DashboardScreen(), // Explicit route for dashboard
      },
      initialRoute: '/', // Set the initial route
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the GlobalState to check session status
    final globalState = Provider.of<GlobalState>(context, listen: true);

    return FutureBuilder<bool>(
      future: _loadUserStatus(globalState),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While loading, show a loading spinner or a splash screen
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Error handling in case the future fails
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          // Check if the user is logged in
          if (snapshot.hasData && snapshot.data == true) {
            // Navigate to Dashboard if logged in, replace the current route stack
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            });
          } else {
            // Otherwise, show the LoginScreen, replace the current route stack
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/login');
            });
          }
          return const SizedBox(); // Return an empty widget while navigating
        }
      },
    );
  }

  Future<bool> _loadUserStatus(GlobalState globalState) async {
    // Check if the email and token are set in the GlobalState (i.e., user is logged in)
    return globalState.email != null && globalState.token != null;
  }
}
