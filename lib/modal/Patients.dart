class Patients {
  late final String id;
  late final String name;
  late final int age;
  late final String address;
  late final String gender;
  late int createdTime = DateTime.now().millisecondsSinceEpoch;

  Patients({
    required this.id,
    required this.name,
    required this.age,
    required this.address,
    required this.gender,
  });

  Patients.fromMap(Map<String, dynamic> result)
      : id = result['id'] as String,
        name = result['name'] as String,
        age = result['age'] as int,
        address = result['address'] as String,
        gender = result['gender'] as String,
        createdTime = result['createdTime'] as int;

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'address': address,
      'gender': gender,
      'createdTime': createdTime
    };
  }
}
