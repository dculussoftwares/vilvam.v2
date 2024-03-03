import 'package:flutter/material.dart';
import 'package:material_3_demo/component/page_wrapper.dart';

import '../component/patient_options.dart';
import '../component/search_patient.dart';

class SearchPatientPage extends StatelessWidget {
  const SearchPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
        child: const ComponentGroupDecoration(
      label: 'Search patients',
      children: [SearchPatient()],
    ));
  }
}
