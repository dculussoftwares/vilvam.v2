import 'package:flutter/material.dart';
import 'package:material_3_demo/component/manage_clinic.dart';
import 'package:material_3_demo/component/page_wrapper.dart';

import '../component/patient_detail.dart';
import '../component/patient_options.dart';

class ManageClinicPage extends StatelessWidget {
  ManageClinicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
        child: ComponentGroupDecoration(
      label: 'Manage clinic',
      children: [ManageClinic()],
    ));
  }
}
