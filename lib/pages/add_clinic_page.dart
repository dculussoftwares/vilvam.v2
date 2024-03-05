import 'package:flutter/material.dart';
import 'package:material_3_demo/component/add_clinic.dart';
import 'package:material_3_demo/component/page_wrapper.dart';

import '../component/add_patient_form.dart';
import '../component/patient_options.dart';

class AddClinicPage extends StatelessWidget {
  AddClinicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
        child: ComponentGroupDecoration(
      label: 'Add clinic',
      children: [AddClinicForm()],
    ));
  }
}
