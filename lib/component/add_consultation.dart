import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_demo/component/_add_consultation_form.dart';
import 'package:material_3_demo/component/page_wrapper.dart';
import 'package:material_3_demo/component/patient_options.dart';

class AddConsultation extends StatelessWidget {
  String patientId;

  AddConsultation({Key? key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    void onConsultationAdd() {
      GoRouter.of(context).pop();
    }

    return PageWrapper(
      child: ComponentGroupDecoration(
        label: "Add consultation",
        children: [
          AddConsultationForm(
              patientId: patientId, onConsultationAdd: onConsultationAdd)
        ],
      ),
    );
  }
}
