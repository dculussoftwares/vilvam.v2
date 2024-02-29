import 'package:material_3_demo/modal/ClinicDetail.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../modal/Patients.dart';

class DataRepository {
  var PATIENTS_TABLE = 'patients';
  var CONSULTATION_TABLE = 'consultation';
  var CLINIC_TABLE = 'clinic';

  Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'patients6.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $PATIENTS_TABLE(id TEXT PRIMARY KEY , name TEXT NOT NULL,age INTEGER NOT NULL,address TEXT NOT NULL,gender TEXT NOT NULL,createdTime INTEGER NOT NULL)',
        );
        await db.execute(
          'CREATE TABLE $CONSULTATION_TABLE(id TEXT PRIMARY KEY ,notes TEXT NOT NULL,patientId INTEGER NOT NULL,createdTime INTEGER NOT NULL)',
        );
        await db.execute(
          'CREATE TABLE $CLINIC_TABLE(id TEXT PRIMARY KEY , name TEXT NOT NULL, location TEXT NOT NULL, isEnabled INTEGER NOT NULL)',
        );
      },
    );
  }

  Future<int> addPatients(List<Patients> patients) async {
    int result = 0;
    final Database db = await initializedDB();
    for (var patient in patients) {
      result = await db.insert(PATIENTS_TABLE, patient.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    return result;
  }

  Future<int> addPatient(Patients patient) async {
    int result = 0;
    final Database db = await initializedDB();
    result = await db.insert(PATIENTS_TABLE, patient.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> addClinic(ClinicDetail clinicDetail) async {
    int result = 0;
    final Database db = await initializedDB();
    result = await db.insert(CLINIC_TABLE, clinicDetail.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<void> updateClinicStatus(ClinicDetail clinicDetail) async {
    final Database db = await initializedDB();
    await db.update(CLINIC_TABLE, clinicDetail.toMap(),
        where: 'id=?', whereArgs: [clinicDetail.id]);
  }

  Future<List<ClinicDetail>> getAllClinic() async {
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult = await db.query(CLINIC_TABLE);
    return queryResult.map((e) => ClinicDetail.fromMap(e)).toList();
  }

  Future<int?> totalPatientCount() async {
    final Database db = await initializedDB();
    final result = await db.rawQuery('SELECT COUNT(*) FROM  $PATIENTS_TABLE');
    return Sqflite.firstIntValue(result);
  }

  Future<Patients?> getPatientById(String patientId) async {
    final Database db = await initializedDB();
    var response =
        await db.query(PATIENTS_TABLE, where: 'id=?', whereArgs: [patientId]);
    return response.isNotEmpty ? Patients.fromMap(response.first) : null;
  }

  Future<List<Patients>> searchPatientByNameAndPhoneNumber(
      String keyword) async {
    final Database db = await initializedDB();
    List<Map<String, dynamic>> allRows = await db.query(PATIENTS_TABLE,
        where: 'name LIKE ? OR address LIKE ?',
        whereArgs: ['%$keyword%', '%$keyword%'],
        orderBy: 'name ASC, address ASC');
    List<Patients> patients =
        allRows.map((patient) => Patients.fromMap(patient)).toList();
    return patients;
  }
}
