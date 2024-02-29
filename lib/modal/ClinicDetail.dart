class ClinicDetail {
  ClinicDetail(
      {required this.id,
      required this.name,
      required this.location,
      required this.isEnabled});

  ClinicDetail.fromMap(Map<String, dynamic> result)
      : id = result['id'] as String,
        name = result['name'] as String,
        isEnabled = (result['isEnabled'] as int) == 1,
        location = result['location'] as String;

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'isEnabled': isEnabled == true ? 1 : 0
    };
  }

  late final String id;
  late final String name;
  late final String location;
  late final bool isEnabled;
  late int createdTime = DateTime.now().millisecondsSinceEpoch;
}
