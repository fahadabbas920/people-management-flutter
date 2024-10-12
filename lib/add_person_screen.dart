import 'package:flutter/material.dart';
import 'language_dropdown.dart';
import 'interests_checkbox.dart';
import 'person.dart';

class AddPersonScreen extends StatefulWidget {
  final void Function(Person) onSave;
  final Person? person;

  const AddPersonScreen({super.key, required this.onSave, this.person});

  @override
  _AddPersonScreenState createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedLanguage;
  List<String> _selectedInterests = [];

  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _idNumberController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _emailController;
  late TextEditingController _birthDateController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _idNumberController = TextEditingController();
    _mobileNumberController = TextEditingController();
    _emailController = TextEditingController();
    _birthDateController = TextEditingController();

    if (widget.person != null) {
      _nameController.text = widget.person!.name;
      _surnameController.text = widget.person!.surname;
      _idNumberController.text = widget.person!.idNumber;
      _mobileNumberController.text = widget.person!.mobileNumber;
      _emailController.text = widget.person!.email;
      _birthDateController.text = widget.person!.birthDate;
      _selectedLanguage = widget.person!.language;
      _selectedInterests = List.from(widget.person!.interests);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _idNumberController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  // Regular expression for validating a South African ID number
  bool _isValidIdNumber(String idNumber) {
    final regex = RegExp(r'^\d{13}$');
    return regex.hasMatch(idNumber) && _isValidIdChecksum(idNumber);
  }

  // Validate the checksum digit of the South African ID number
  bool _isValidIdChecksum(String idNumber) {
    int sum = 0;
    for (int i = 0; i < idNumber.length; i++) {
      int digit = int.parse(idNumber[i]);
      if (i % 2 == 0) {
        sum += digit; // Sum of digits in even positions (0-based index)
      } else {
        int doubled = digit * 2;
        sum += (doubled > 9) ? doubled - 9 : doubled; // Add digits of doubled number
      }
    }
    return sum % 10 == 0; // Check if sum is divisible by 10
  }

  // Regular expression for validating date format (YYYY-MM-DD)
  bool _isValidDate(String date) {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(date)) {
      return false;
    }
    // Further validation can be done to check if the date is valid
    try {
      DateTime.parse(date);
      return true;
    } catch (e) {
      return false;
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
              _buildTextField('Name', _nameController),
              _buildTextField('Surname', _surnameController),
              _buildTextField('South African ID Number', _idNumberController, TextInputType.number, _isValidIdNumber),
              _buildTextField('Mobile Number', _mobileNumberController, TextInputType.phone),
              _buildTextField('Email Address', _emailController, TextInputType.emailAddress),
              _buildTextField('Birth Date (YYYY-MM-DD)', _birthDateController, TextInputType.datetime, _isValidDate),
              LanguageDropdown(
                onLanguageSelected: (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
                selectedLanguage: _selectedLanguage,
              ),
              InterestsCheckbox(
                selectedInterests: _selectedInterests,
                onInterestsChanged: (List<String> interests) {
                  setState(() {
                    _selectedInterests = interests;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final person = Person(
                      name: _nameController.text,
                      surname: _surnameController.text,
                      idNumber: _idNumberController.text,
                      mobileNumber: _mobileNumberController.text,
                      email: _emailController.text,
                      birthDate: _birthDateController.text,
                      language: _selectedLanguage ?? '',
                      interests: _selectedInterests,
                    );
                    widget.onSave(person);
                  }
                },
                child: Text(widget.person == null ? 'Save' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, [TextInputType? inputType, Function(String)? validator]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: inputType ?? TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (validator != null && !validator(value)) {
          return 'Invalid format for $label';
        }
        return null;
      },
    );
  }
}
