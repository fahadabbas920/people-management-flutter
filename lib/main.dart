import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'global_state.dart';
import 'login_screen.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => GlobalState(),
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Person App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
