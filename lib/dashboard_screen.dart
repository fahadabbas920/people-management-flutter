import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/login_screen.dart';
import 'add_person_screen.dart';
import 'person.dart';
import 'global_state.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Person> _persons = [];

  @override
  void initState() {
    super.initState();
    _fetchPersons();
  }

  Future<void> _fetchPersons() async {
    final String peopleUrl = '${dotenv.env['BASE_URL']}/api/people';
    try {
      final response = await http.get(Uri.parse(peopleUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _persons = responseData
              .map((personData) => Person.fromJson(personData))
              .toList();
        });
            } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch persons: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error fetching persons: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while fetching data.')),
      );
    }
  }

  void _addOrUpdatePerson(Person person, [int? index]) {
    setState(() {
      if (index != null) {
        // Update existing person
        _persons[index] = person;
      } else {
        // Add new person
        _persons.add(person);
      }
    });
  }

  void _removePerson(int index) async {
    final personId = _persons[index].id;
    final String deleteUrl = '${dotenv.env['BASE_URL']}/api/people/$personId';

    try {
      final response = await http.delete(Uri.parse(deleteUrl));
      if (response.statusCode == 200) {
        setState(() {
          _persons.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Person deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete person')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while deleting the person.')),
      );
    }
  }

  void _navigateToAddPersonScreen(BuildContext context,
      [Person? person, int? index]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPersonScreen(
          onSave: (newPerson) {
            _addOrUpdatePerson(newPerson, index);
            Navigator.pop(context);
          },
          person: person,
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final String logoutUrl = '${dotenv.env['BASE_URL']}/api/logout';
    try {
      final response = await http.post(Uri.parse(logoutUrl));

      if (response.statusCode == 200) {
        // Clear global state
        await Provider.of<GlobalState>(context, listen: false).clearEmail();

        // Navigate back to LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to logout')),
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
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _persons.isEmpty
          ? const Center(child: Text('No persons added.'))
          : ListView.builder(
              itemCount: _persons.length,
              itemBuilder: (context, index) {
                final person = _persons[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('${person.name} ${person.surname}'),
                    subtitle: Text(
                      'ID: ${person.idNumber}\n'
                      'Mobile: ${person.mobileNumber}\n'
                      'Email: ${person.email}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _navigateToAddPersonScreen(
                              context, person, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removePerson(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add), label: 'Add Person'),
        ],
        onTap: (index) {
          if (index == 1) {
            _navigateToAddPersonScreen(context);
          }
        },
      ),
    );
  }
}
