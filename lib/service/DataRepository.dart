import 'package:material_3_demo/modal/ClinicDetail.dart';
import 'package:material_3_demo/modal/Consultation.dart';
import 'package:material_3_demo/modal/PatientConsultation.dart';
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
      join(path, 'patients9.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $PATIENTS_TABLE(id TEXT PRIMARY KEY , name TEXT NOT NULL,age INTEGER NOT NULL,address TEXT NOT NULL,gender TEXT NOT NULL,createdTime INTEGER NOT NULL,phoneNumber INTEGER NOT NULL)',
        );
        await db.execute(
          'CREATE TABLE $CONSULTATION_TABLE(id TEXT PRIMARY KEY ,notes TEXT NOT NULL,patientId INTEGER NOT NULL,createdTime INTEGER NOT NULL, clinicId TEXT NOT NULL)',
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

  Future<List<ClinicDetail>> getAllActiveClinic() async {
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult =
        await db.query(CLINIC_TABLE, where: 'isEnabled = ?', whereArgs: [1]);
    return queryResult.map((e) => ClinicDetail.fromMap(e)).toList();
  }

  Future<int?> totalPatientCount() async {
    final Database db = await initializedDB();
    final result = await db.rawQuery('SELECT COUNT(*) FROM  $PATIENTS_TABLE');
    return Sqflite.firstIntValue(result);
  }

  Future<int?> totalConsultationCountByPatient(String patientId) async {
    final Database db = await initializedDB();
    // final result =
    //     await db.rawQuery('SELECT COUNT(*) FROM  $CONSULTATION_TABLE');
    // return Sqflite.firstIntValue(result);
    return Sqflite.firstIntValue(await db.query(
          CONSULTATION_TABLE,
          columns: ['COUNT(*)'],
          where: 'patientId = ?',
          whereArgs: [patientId],
        )) ??
        0;
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
        where: 'name LIKE ? OR phoneNumber LIKE ? OR address LIKE ?',
        whereArgs: ['%$keyword%', '%$keyword%', '%$keyword%'],
        orderBy: 'name ASC, phoneNumber ASC, address ASC');
    List<Patients> patients =
        allRows.map((patient) => Patients.fromMap(patient)).toList();
    return patients;
  }

  Future<int> addConsultation(Consultation consultation) async {
    int result = 0;
    final Database db = await initializedDB();
    result = await db.insert(CONSULTATION_TABLE, consultation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<ClinicConsultation>> getAllConsultationByPatientId(
      String id) async {
    final Database db = await initializedDB();
    List<Map<String, dynamic>> allRows = await db.query(CONSULTATION_TABLE,
        where: 'patientId=?', whereArgs: [id], orderBy: 'createdTime DESC');
    List<Consultation> consultations =
        allRows.map((contact) => Consultation.fromMap(contact)).toList();

    List<ClinicDetail> allClinics = await getAllClinic();
    List<ClinicConsultation> clinicConsultation = [];

    for (var consultation in consultations) {
      var clinicDetail =
          allClinics.where((element) => element.id == consultation.id).first;
      clinicConsultation.add(ClinicConsultation(
          consultation: consultation, clinicDetails: clinicDetail));
    }

    // consultations.map((consultation) => {
    // ClinicDetail clinicDetail=allClinics.where((element) => element.id == consultation.id).first();
    //     patientConsultation.add(ClinicConsultation(consultation: consultation,
    //     clinicDetails: clinicDetails))}
    // );
    return clinicConsultation;
  }
}
