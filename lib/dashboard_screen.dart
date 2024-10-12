import 'package:flutter/material.dart';
import 'add_person_screen.dart';
import 'person.dart';
import 'global_state.dart'; // Import the GlobalState
import 'package:provider/provider.dart'; // Import provider package

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Person> _persons = [];

  void _addOrUpdatePerson(Person person, [int? index]) {
    if (index != null) {
      // Update existing person
      setState(() {
        _persons[index] = person;
      });
    } else {
      // Add new person
      setState(() {
        _persons.add(person);
      });
    }
  }

  void _removePerson(int index) {
    setState(() {
      _persons.removeAt(index);
    });
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

  void _logout(BuildContext context) {
    // Clear global state
    Provider.of<GlobalState>(context, listen: false).clearEmail();

    // Navigate back to LoginScreen
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context), // Logout action
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
                    subtitle: Text('ID: ${person.idNumber}'),
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
