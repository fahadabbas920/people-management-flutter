import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'global_state.dart';
import 'package:provider/provider.dart';
import 'add_person_screen.dart';
import 'person.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Person> _persons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPersons();
  }

  Future<void> _fetchPersons() async {
    final String fetchUrl = '${dotenv.env['BASE_URL']}/api/people';
    final token = Provider.of<GlobalState>(context, listen: false).token ?? '';

    try {
      final response = await http.get(
        Uri.parse(fetchUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add token to Authorization header
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _persons =
              data.map((personJson) => Person.fromJson(personJson)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load persons');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load persons')),
      );
    }
  }

  Future<void> _deletePerson(int personId) async {
    // Change personId to int
    final String deleteUrl = '${dotenv.env['BASE_URL']}/api/people/$personId';
    final token = Provider.of<GlobalState>(context, listen: false).token ?? '';

    try {
      final response = await http.delete(
        Uri.parse(deleteUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Use token in Authorization header
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _persons.removeWhere(
              (person) => person.id == personId); // Handle with int
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Person deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete person: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during deletion.')),
      );
    }
  }

  void _editPerson(Person person) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPersonScreen(
          onSave: (updatedPerson) {
            setState(() {
              int index = _persons.indexWhere((p) => p.id == updatedPerson.id);
              if (index != -1) {
                _persons[index] = updatedPerson; // Update person in list
              }
            });
          },
          person: person, // Pass the person to edit
        ),
      ),
    );
  }

  void _onSave(Person person) {
    setState(() {
      _persons.add(person); // Add newly created person to list
    });
  }

  Future<void> _logout() async {
    final String logoutUrl = '${dotenv.env['BASE_URL']}/api/logout';
    final token = Provider.of<GlobalState>(context, listen: false).token ?? '';

    try {
      final response = await http.post(
        Uri.parse(logoutUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Provider.of<GlobalState>(context, listen: false).clearSession();
        Navigator.pushReplacementNamed(context, '/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to logout: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during logout.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _persons.length,
              itemBuilder: (context, index) {
                final person = _persons[index];
                return ListTile(
                  title: Text('${person.name} ${person.surname}'),
                  subtitle: Text(person.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editPerson(person), // Edit person
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _deletePerson(person.id), // Delete person as int
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPersonScreen(onSave: _onSave),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
