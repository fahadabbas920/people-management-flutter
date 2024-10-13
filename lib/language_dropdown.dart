import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  final Function(String?) onLanguageSelected;
  final String? selectedLanguage;

  final List<String> languages = ['English', 'Afrikaans', 'Zulu'];

  LanguageDropdown({super.key, required this.onLanguageSelected, this.selectedLanguage, required Null Function(dynamic value) onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Language'),
      items: languages
          .map((language) =>
              DropdownMenuItem(value: language, child: Text(language)))
          .toList(),
      onChanged: onLanguageSelected,
      value: selectedLanguage,
      validator: (value) {
        if (value == null) {
          return 'Please select a language';
        }
        return null;
      },
    );
  }
}
