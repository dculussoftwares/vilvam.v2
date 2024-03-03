import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_demo/component/_add_consultation_form.dart';
import 'package:material_3_demo/component/page_wrapper.dart';

class AddConsultation extends StatelessWidget {
  String patientId;

  AddConsultation({Key? key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    // var patientId = routes["patientId"] as String;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    void onConsultationAdd() {
      GoRouter.of(context).pop();
    }

    return PageWrapper(
      child: AddConsultationForm(
          patientId: patientId, onConsultationAdd: onConsultationAdd),
    );

    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(color: colorScheme.surface),
        child: Align(
            alignment: Alignment.topLeft,
            // widthFactor: widthAnimation.value,
            child: Scaffold(
              body: Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_circle_left),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    AddConsultationForm(
                        patientId: patientId,
                        onConsultationAdd: onConsultationAdd),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
