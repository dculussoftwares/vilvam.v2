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
    // automatically creates 1 empty sheet: Sheet1
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Clinics'];
    CellStyle cellStyle = CellStyle(
        backgroundColorHex: '#1AFF1A',
        fontFamily: getFontFamily(FontFamily.Calibri));
    var allClinics = await dataRepository.getAllClinic();

    int index = 1;
    var clinicIdColumnName = 'A';
    var clinicNameColumnName = 'B';
    var clinicLocationColumnName = 'C';
    var clinicStatusColumnName = 'D';

    for (var clinic in allClinics) {
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
          .value = BoolCellValue(clinic.isEnabled);
    }

    var fileBytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();
    var pathh = '${directory.path}/export.xlsx';

    File(pathh)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);


    final result =
    await Share.shareXFiles([XFile(pathh)], text: 'Great picture');

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
