import 'dart:io';

import 'package:excel/excel.dart';
import 'package:material_3_demo/modal/ClinicDetail.dart';
import 'package:material_3_demo/modal/Patients.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../constants.dart';
import '../main.dart';

class DataExportService {
  Future exportAllDataAsExcel() async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel[clinicsSheet];

    await generateClinicExcel(sheetObject);

    sheetObject = excel[patientSheet];

    await generatePatientExcel(sheetObject);

    sheetObject = excel[consultationSheet];

    await generateConsultationSheetExcel(sheetObject);

    var fileBytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();
    var pathh = '${directory.path}/export.xlsx';
    print(pathh);

    File(pathh)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    final result = await Share.shareXFiles([XFile(pathh)], text: 'Exports');

    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing the picture!');
    }
  }

  Future<void> generatePatientExcel(Sheet sheetObject) async {
    var allPatients = await dataRepository.getAllPatients();
    int index = 1;
    var patientIdColumnName = 'A';
    var patientNameColumnName = 'B';
    var patientAgeColumnName = 'C';
    var patientAddressColumnName = 'D';
    var patientGenderColumnName = 'E';
    var patientPhoneNumberColumnName = 'F';
    var patientCreatedColumnName = 'G';

    sheetObject
        .cell(CellIndex.indexByString(patientIdColumnName + index.toString()))
        .value = const TextCellValue("Patient Id");

    sheetObject
        .cell(CellIndex.indexByString(patientNameColumnName + index.toString()))
        .value = const TextCellValue("Patient Name");
    sheetObject
        .cell(CellIndex.indexByString(patientAgeColumnName + index.toString()))
        .value = const TextCellValue("Patient Age");
    sheetObject
        .cell(CellIndex.indexByString(
            patientAddressColumnName + index.toString()))
        .value = const TextCellValue("Patient Address");
    sheetObject
        .cell(
            CellIndex.indexByString(patientGenderColumnName + index.toString()))
        .value = const TextCellValue("Patient Gender");
    sheetObject
        .cell(CellIndex.indexByString(
            patientPhoneNumberColumnName + index.toString()))
        .value = const TextCellValue("Patient Phone number");
    sheetObject
        .cell(CellIndex.indexByString(
            patientCreatedColumnName + index.toString()))
        .value = const TextCellValue("Patient Created time");

    for (var patient in allPatients) {
      ++index;
      sheetObject
          .cell(CellIndex.indexByString(patientIdColumnName + index.toString()))
          .value = TextCellValue(patient.id);

      sheetObject
          .cell(
              CellIndex.indexByString(patientNameColumnName + index.toString()))
          .value = TextCellValue(patient.name);

      sheetObject
          .cell(
              CellIndex.indexByString(patientAgeColumnName + index.toString()))
          .value = TextCellValue(patient.age.toString());

      sheetObject
          .cell(CellIndex.indexByString(
              patientAddressColumnName + index.toString()))
          .value = TextCellValue(patient.address);
      sheetObject
          .cell(CellIndex.indexByString(
              patientGenderColumnName + index.toString()))
          .value = TextCellValue(patient.gender);

      sheetObject
          .cell(CellIndex.indexByString(
              patientPhoneNumberColumnName + index.toString()))
          .value = TextCellValue(patient.phoneNumber.toString());

      sheetObject
              .cell(CellIndex.indexByString(
                  patientCreatedColumnName + index.toString()))
              .value =
          TextCellValue(DateTime.fromMillisecondsSinceEpoch(patient.createdTime)
              .toString());
    }
  }

  Future generateClinicExcel(Sheet sheetObject) async {
    var allClinics = await dataRepository.getAllClinic();
    int index = 1;
    var clinicIdColumnName = 'A';
    var clinicNameColumnName = 'B';
    var clinicLocationColumnName = 'C';
    var clinicStatusColumnName = 'D';
    var clinicCreatedColumnName = 'E';

    sheetObject
        .cell(CellIndex.indexByString(clinicIdColumnName + index.toString()))
        .value = const TextCellValue("Clinic Id");

    sheetObject
        .cell(CellIndex.indexByString(clinicNameColumnName + index.toString()))
        .value = const TextCellValue("Clinic Name");
    sheetObject
        .cell(CellIndex.indexByString(
            clinicLocationColumnName + index.toString()))
        .value = const TextCellValue("Clinic Location");
    sheetObject
        .cell(
            CellIndex.indexByString(clinicStatusColumnName + index.toString()))
        .value = const TextCellValue("Clinic Status");
    sheetObject
        .cell(
            CellIndex.indexByString(clinicCreatedColumnName + index.toString()))
        .value = const TextCellValue("Patient Created time");

    for (var clinic in allClinics) {
      ++index;
      sheetObject
          .cell(CellIndex.indexByString(clinicIdColumnName + index.toString()))
          .value = TextCellValue(clinic.id);

      sheetObject
          .cell(
              CellIndex.indexByString(clinicNameColumnName + index.toString()))
          .value = TextCellValue(clinic.name);
      sheetObject
          .cell(CellIndex.indexByString(
              clinicLocationColumnName + index.toString()))
          .value = TextCellValue(clinic.location);
      sheetObject
          .cell(CellIndex.indexByString(
              clinicStatusColumnName + index.toString()))
          .value = TextCellValue(clinic.isEnabled ? "true" : "false");

      sheetObject
              .cell(CellIndex.indexByString(
                  clinicCreatedColumnName + index.toString()))
              .value =
          TextCellValue(DateTime.fromMillisecondsSinceEpoch(clinic.createdTime)
              .toString());
    }
  }

  Future generateConsultationSheetExcel(Sheet sheetObject) async {
    var allConsultation = await dataRepository.getAllConsultation();
    int index = 1;
    var consultationIdColumnName = 'A';
    var consultationNotesColumnName = 'B';
    var consultationPatientIdColumnName = 'C';
    var consultationClinicIdColumnName = 'D';
    var consultationCreatedColumnName = 'E';

    sheetObject
        .cell(CellIndex.indexByString(
            consultationIdColumnName + index.toString()))
        .value = const TextCellValue("Consultation Id");

    sheetObject
        .cell(CellIndex.indexByString(
            consultationNotesColumnName + index.toString()))
        .value = const TextCellValue("Consultation Notes");
    sheetObject
        .cell(CellIndex.indexByString(
            consultationPatientIdColumnName + index.toString()))
        .value = const TextCellValue("Consultation Patient Id");
    sheetObject
        .cell(CellIndex.indexByString(
            consultationClinicIdColumnName + index.toString()))
        .value = const TextCellValue("Consultation Clinic Id");

    sheetObject
        .cell(CellIndex.indexByString(
            consultationCreatedColumnName + index.toString()))
        .value = const TextCellValue("Consultation Created Time");

    for (var consultation in allConsultation) {
      ++index;
      sheetObject
          .cell(CellIndex.indexByString(
              consultationIdColumnName + index.toString()))
          .value = TextCellValue(consultation.id);

      sheetObject
          .cell(CellIndex.indexByString(
              consultationNotesColumnName + index.toString()))
          .value = TextCellValue(consultation.notes);
      sheetObject
          .cell(CellIndex.indexByString(
              consultationPatientIdColumnName + index.toString()))
          .value = TextCellValue(consultation.patientId);
      sheetObject
          .cell(CellIndex.indexByString(
              consultationClinicIdColumnName + index.toString()))
          .value = TextCellValue(consultation.clinicId);

      sheetObject
              .cell(CellIndex.indexByString(
                  consultationCreatedColumnName + index.toString()))
              .value =
          TextCellValue(
              DateTime.fromMillisecondsSinceEpoch(consultation.createdTime)
                  .toString());
    }
  }
}
