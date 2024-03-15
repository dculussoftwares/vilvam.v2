import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_3_demo/component/page_wrapper.dart';
import 'package:material_3_demo/main.dart';
import 'package:material_3_demo/ui/buttons.dart';

import '../component/patient_options.dart';

class ExportDataPage extends StatelessWidget {
  ExportDataPage({super.key});

  Duration t = $styles.times.med;

  Future<void> onGenerateReport() async {
    await dataExportService.exportAllDataAsExcel();
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
