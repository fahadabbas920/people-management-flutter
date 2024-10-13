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
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadEmail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While loading, show a loading spinner
          return const Center(child: CircularProgressIndicator());
        } else {
          // Check if the email is not null (indicating a logged-in user)
          if (snapshot.hasData && snapshot.data != null) {
            return DashboardScreen(); // Navigate to Dashboard if logged in
          } else {
            return LoginScreen(); // Otherwise show LoginScreen
          }
        }
      },
    );
  }

  Future<String?> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email'); // Load email from SharedPreferences
  }
}
