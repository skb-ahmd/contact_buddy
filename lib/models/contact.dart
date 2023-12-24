// models/contact.dart

class Contact {
  final int? id;
  final String name;
  final String phone;
  final String email;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }

  // Add a copyWith method for easy updating of Contact objects
  Contact copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}
