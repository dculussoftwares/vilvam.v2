import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_demo/component/_add_consultation_form.dart';
import 'package:material_3_demo/component/page_wrapper.dart';
import 'package:material_3_demo/component/patient_options.dart';

import 'edit_consultation_form.dart';

class EditConsultation extends StatelessWidget {
  String consultationId;

  EditConsultation({Key? key, required this.consultationId});

  @override
  Widget build(BuildContext context) {
    void onConsultationAdd() {
      GoRouter.of(context).pop();
    }

    return PageWrapper(
      child: ComponentGroupDecoration(
        label: "Edit consultation",
        children: [
          EditConsultationForm(
            consultationId: consultationId,
          )
        ],
      ),
    );
  }
}
