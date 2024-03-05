import 'package:flutter/material.dart';
import 'package:material_3_demo/component/page_wrapper.dart';

import '../component/add_patient_form.dart';
import '../component/patient_options.dart';

class AddPatientPage extends StatelessWidget {
  String? patientId;
  bool? isEdit = false;

  AddPatientPage({super.key, this.patientId, this.isEdit});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
        child: ComponentGroupDecoration(
      label: isEdit == true ? "Edit patient" : 'Add patient',
      children: [
        AddPatientForm(
          patientId: patientId,
          isEdit: isEdit,
        )
      ],
    ));
  }
}
