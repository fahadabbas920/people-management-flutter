import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'global_state.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        '/login': (context) =>  LoginScreen(), // Explicit route for login
        '/dashboard': (context) => const DashboardScreen(), // Explicit route for dashboard
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
    return FutureBuilder<bool>(
      future: _loadUserStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While loading, show a loading spinner
          return const Center(child: CircularProgressIndicator());
        } else {
          // Check if the user is logged in
          if (snapshot.hasData && snapshot.data == true) {
            // Navigate to Dashboard if logged in
            return const DashboardScreen();
          } else {
            // Otherwise show LoginScreen
            return  LoginScreen();
          }
        }
      },
    );
  }

  Future<bool> _loadUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final csrfToken = prefs.getString('csrf_token'); // Load CSRF token if needed

    // Check if both email and CSRF token are present
    return email != null && csrfToken != null; // Return true if both are present
  }
}
