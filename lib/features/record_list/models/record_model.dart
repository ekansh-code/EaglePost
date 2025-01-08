class RecordModel {
  final int id;
  final String name;
  final String email;
  final int age;
  final String city;
  final String state;

  RecordModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.city,
    required this.state,
  });

  // Factory constructor to create RecordModel from JSON
  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      age: json['age'] ?? 0,
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'city': city,
      'state': state,
    };
  }
} 