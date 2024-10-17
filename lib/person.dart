class Person {
  final int id; // Add id property
  final String name;
  final String surname;
  final String south_african_id_number; // Change to match the JSON key
  final String mobile_number; // Add mobile number property
  final String email; // Add email property
  final String date_of_birth; // Add date of birth property
  final String language; // Add language property
  final List<String> interests; // Add interests property

  Person({
    required this.id,
    required this.name,
    required this.surname,
    required this.south_african_id_number,
    required this.mobile_number,
    required this.email,
    required this.date_of_birth,
    required this.language,
    required this.interests,
    required String birthDate,
  });
  // Convert a Person object into a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'south_african_id_number': south_african_id_number,
      'mobile_number': mobile_number,
      'email': email,
      'date_of_birth': date_of_birth,
      'language': language,
      'interests': interests,
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      south_african_id_number: json['south_african_id_number'],
      mobile_number: json['mobile_number'],
      email: json['email'],
      date_of_birth: json['date_of_birth'],
      language: json['language'],
      interests: List<String>.from(json['interests'] ?? []),
      birthDate: '', // Safely handle null
    );
  }

  get birthDate => null;
}
