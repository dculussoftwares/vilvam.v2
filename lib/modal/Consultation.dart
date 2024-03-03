class Consultation {
  late final String id;
  late final String notes;
  late final String patientId;
  late int createdTime = DateTime.now().millisecondsSinceEpoch;

  Consultation({
    required this.id,
    required this.notes,
    required this.patientId,
  });

  Consultation.fromMap(Map<String, dynamic> result)
      : id = result['id'] as String,
        notes = result['notes'] as String,
        patientId = result['patientId'] as String,
        createdTime = result['createdTime'] as int;

  Map<String, Object> toMap() {
    return {
      'id': id,
      'notes': notes,
      'patientId': patientId,
      'createdTime': createdTime
    };
  }
}
