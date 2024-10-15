import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'global_state.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/api/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final user = responseBody['user'];
        final token = responseBody['token'];
        String userId = user['id'].toString();
        // Save email, user data, and token in global state
        Provider.of<GlobalState>(context, listen: false)
            .setEmailAndToken(email, token, userId, user['name']);

        // Navigate to the Dashboard after successful login
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Handle login failure
        _showErrorDialog(
            'Login failed. Please check your credentials and try again.');
      }
    } catch (e) {
      // Handle exceptions
      _showErrorDialog('An error occurred: $e');
    }
  }

  String extractCsrfToken(String? cookies) {
    if (cookies != null) {
      // Split cookies and find CSRF token
      final cookieList = cookies.split(';');
      for (var cookie in cookieList) {
        if (cookie.contains('XSRF-TOKEN')) {
          // Adjust based on actual cookie name
          return cookie.split('=')[1].trim();
        }
      }
    }
    throw Exception('CSRF token not found in cookies');
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your password' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
