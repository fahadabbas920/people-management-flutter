import 'package:flutter/material.dart';

class InterestsCheckbox extends StatelessWidget {
  final List<String> selectedInterests;
  final Function(List<String>) onInterestsChanged;

  final List<String> interests = ['Reading', 'Sports', 'Traveling', 'Music'];

  InterestsCheckbox({super.key, required this.selectedInterests, required this.onInterestsChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: interests
          .map((interest) => CheckboxListTile(
                title: Text(interest),
                value: selectedInterests.contains(interest),
                onChanged: (bool? value) {
                  if (value == true) {
                    selectedInterests.add(interest);
                  } else {
                    selectedInterests.remove(interest);
                  }
                  onInterestsChanged(List.from(selectedInterests));
                },
              ))
          .toList(),
    );
  }
}
