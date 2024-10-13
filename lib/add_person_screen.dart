import 'package:flutter/material.dart';
import 'package:myapp/dashboard_screen.dart';
import 'person.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddPersonScreen extends StatefulWidget {
  final Function(Person) onSave;
  final Person? person;

  const AddPersonScreen({Key? key, required this.onSave, this.person})
      : super(key: key);

  @override
  _AddPersonScreenState createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _idNumberController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _emailController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _languageController;
  late TextEditingController _interestsController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.person?.name ?? '');
    _surnameController =
        TextEditingController(text: widget.person?.surname ?? '');
    _idNumberController =
        TextEditingController(text: widget.person?.idNumber ?? '');
    _mobileNumberController =
        TextEditingController(text: widget.person?.mobileNumber ?? '');
    _emailController = TextEditingController(text: widget.person?.email ?? '');
    _dateOfBirthController =
        TextEditingController(text: widget.person?.dateOfBirth ?? '');
    _languageController =
        TextEditingController(text: widget.person?.language ?? '');
    _interestsController = TextEditingController(
        text: widget.person?.interests.join(', ') ?? ''); // For displaying interests
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _idNumberController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    _languageController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  Future<void> _savePerson() async {
    if (_formKey.currentState?.validate() != true) return;

    final newPerson = Person(
      id: widget.person?.id ?? 0, // If new person, id will be 0
      name: _nameController.text,
      surname: _surnameController.text,
      idNumber: _idNumberController.text,
      mobileNumber: _mobileNumberController.text,
      email: _emailController.text,
      dateOfBirth: _dateOfBirthController.text,
      language: _languageController.text,
      interests: _interestsController.text.split(',').map((e) => e.trim()).toList(), birthDate: '',
    );


    // Check if it's an update or a new person
    if (widget.person != null) {
      await _updatePerson(newPerson);
    } else {
      await _createPerson(newPerson);
    }
  }

  Future<void> _createPerson(Person person) async {
    final String createUrl = '${dotenv.env['BASE_URL']}/api/people';
    try {
      final response = await http.post(
        Uri.parse(createUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': person.name,
          'surname': person.surname,
          'south_african_id_number': person.idNumber,
          'mobile_number': person.mobileNumber,
          'email': person.email,
          'date_of_birth': person.dateOfBirth,
          'language': person.language,
          'interests': person.interests,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final createdPerson = Person.fromJson(responseData);

        widget.onSave(createdPerson); // Send created person to the parent widget
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        ); // Close the form after saving
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Person added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add person: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while adding person.')),
      );
    }
  }

  Future<void> _updatePerson(Person person) async {
    final String updateUrl = '${dotenv.env['BASE_URL']}/api/people/${person.id}';
    try {
      final response = await http.put(
        Uri.parse(updateUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': person.name,
          'surname': person.surname,
          'south_african_id_number': person.idNumber,
          'mobile_number': person.mobileNumber,
          'email': person.email,
          'date_of_birth': person.dateOfBirth,
          'language': person.language,
          'interests': person.interests,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final updatedPerson = Person.fromJson(responseData);

        widget.onSave(updatedPerson); // Send updated person to the parent widget
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        ); // Close the form after saving
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Person updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update person: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while updating person.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person == null ? 'Add Person' : 'Edit Person'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _surnameController,
                decoration: const InputDecoration(labelText: 'Surname'),
                validator: (value) => value!.isEmpty ? 'Please enter a surname' : null,
              ),
              TextFormField(
                controller: _idNumberController,
                decoration: const InputDecoration(labelText: 'ID Number'),
                validator: (value) => value!.isEmpty ? 'Please enter an ID number' : null,
              ),
              TextFormField(
                controller: _mobileNumberController,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                validator: (value) => value!.isEmpty ? 'Please enter a mobile number' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
              ),
              TextFormField(
                controller: _dateOfBirthController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                validator: (value) => value!.isEmpty ? 'Please enter a date of birth' : null,
              ),
              TextFormField(
                controller: _languageController,
                decoration: const InputDecoration(labelText: 'Language'),
                validator: (value) => value!.isEmpty ? 'Please enter a language' : null,
              ),
              TextFormField(
                controller: _interestsController,
                decoration: const InputDecoration(labelText: 'Interests (comma-separated)'),
                validator: (value) => value!.isEmpty ? 'Please enter interests' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePerson,
                child: Text(widget.person == null ? 'Add Person' : 'Update Person'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
