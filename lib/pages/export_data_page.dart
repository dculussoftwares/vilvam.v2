import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_3_demo/component/add_clinic.dart';
import 'package:material_3_demo/component/page_wrapper.dart';
import 'package:material_3_demo/main.dart';
import 'package:material_3_demo/ui/buttons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../component/add_patient_form.dart';
import '../component/patient_options.dart';

class ExportDataPage extends StatelessWidget {
  ExportDataPage({super.key});

  Duration t = $styles.times.med;

  Future<void> onGenerateReport() async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Clinics'];
    var allClinics = await dataRepository.getAllClinic();
    var allPatients = await dataRepository.getAllPatients();

    int index = 1;
    var clinicIdColumnName = 'A';
    var clinicNameColumnName = 'B';
    var clinicLocationColumnName = 'C';
    var clinicStatusColumnName = 'D';

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
    }

    sheetObject = excel['Patient'];

    index = 1;
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

      print(patient.name);
      print(patient.age);

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

    var fileBytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();
    var pathh = '${directory.path}/export.xlsx';

    File(pathh)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    final result = await Share.shareXFiles([XFile(pathh)], text: 'Exports');

    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing the picture!');
    }
    // File(join('output_file_name.xlsx'))
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
        child: ComponentGroupDecoration(
      label: 'Export Data ',
      children: [
        Column(
          children: [
            AppBtn.from(
              text: "Export",
              onPressed: () {
                onGenerateReport();
              },
            ).animate().fadeIn(delay: t).move(
                  begin: const Offset(0, 50),
                  duration: t,
                  curve: Curves.easeOutCubic,
                )
          ],
        )
      ],
    ));
  }
}
