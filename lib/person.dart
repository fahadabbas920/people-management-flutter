class Person {
  final int id; // Add id property
  final String name;
  final String surname;
  final String idNumber; // Change to match the JSON key
  final String mobileNumber; // Add mobile number property
  final String email; // Add email property
  final String dateOfBirth; // Add date of birth property
  final String language; // Add language property
  final List<String> interests; // Add interests property

  Person({
    required this.id,
    required this.name,
    required this.surname,
    required this.idNumber,
    required this.mobileNumber,
    required this.email,
    required this.dateOfBirth,
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
      'idNumber': idNumber,
      'mobileNumber': mobileNumber,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'language': language,
      'interests': interests,
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      idNumber: json['south_african_id_number'],
      mobileNumber: json['mobile_number'],
      email: json['email'],
      dateOfBirth: json['date_of_birth'],
      language: json['language'],
      interests: List<String>.from(json['interests'] ?? []),
      birthDate: '', // Safely handle null
    );
  }

  get birthDate => null;
}
