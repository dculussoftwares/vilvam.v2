import 'package:flutter/material.dart';
import 'package:material_3_demo/component/page_wrapper.dart';

import '../component/patient_detail.dart';
import '../component/patient_options.dart';

class PatientDetailPage extends StatelessWidget {
  PatientDetailPage({super.key, required this.patientId});

  String patientId;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
        child: ComponentGroupDecoration(
      label: 'Patient detail',
      children: [PatientDetailScreen(patientId: patientId)],
    ));
  }
}
