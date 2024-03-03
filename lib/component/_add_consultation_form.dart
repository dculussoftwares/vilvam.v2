import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:material_3_demo/main.dart';
import 'package:material_3_demo/modal/Consultation.dart';
import 'package:material_3_demo/ui/buttons.dart';
import 'package:material_3_demo/ui/form_text_field.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

class AddConsultationForm extends StatefulWidget {
  AddConsultationForm({
    Key? key,
    required this.patientId,
    required this.onConsultationAdd,
  }) : super(key: key);
  String patientId;
  final void Function() onConsultationAdd;

  @override
  State<AddConsultationForm> createState() => _AddConsultationFormState();
}

class _AddConsultationFormState extends State<AddConsultationForm> {
  final _formKey = GlobalKey<FormState>();
  String? notes;

  Future<void> _handleOnConsultationAdd(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var uuid = const Uuid();
      await dataRepository.addConsultation(Consultation(
          id: uuid.v4().toString(),
          notes: notes ?? '',
          patientId: widget.patientId));
      if (context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          title: const Text('Success!'),
          description: const Text('Added consultation successfully'),
          autoCloseDuration: const Duration(seconds: 3),
        );
        widget.onConsultationAdd();
        // Navigator.pop(context);
      }
      // var totalConsultation =
      //     await patientsServiceLogic.totalConsultationCount();
      // var result = await patientsServiceLogic.addConsultation(Consultation(
      //     id: totalConsultation + 1,
      //     notes: notes ?? '',
      //     patientId: int.parse(widget.patientId)));
      // var c = 7;
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration t = $styles.times.med;
    return Column(
      children: [
        Gap($styles.insets.xl),
        Text(
          'OMMM',
          style: $styles.text.titleFont.copyWith(color: $styles.colors.accent1),
        ).animate().fade(delay: 150.ms, duration: 600.ms),
        Gap($styles.insets.xs),
        Semantics(
          header: true,
          child: Text(
            "SSSIVVAAMMAMAMA",
            textAlign: TextAlign.center,
            style: $styles.text.h2
                .copyWith(color: $styles.colors.offWhite, height: 1.2),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ).animate().fade(delay: 250.ms, duration: 600.ms),
        ),
        Gap($styles.insets.lg),
        Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...[
                  FormTextField(
                      // darkBackground: true,
                      labelName: "Notes",
                      validationMessage: "Notes is required",
                      onSaved: (value) {
                        notes = value;
                      }),
                ]
                    .animate(interval: 100.ms)
                    .fadeIn(delay: 600.ms, duration: $styles.times.med)
                    .slide(begin: Offset(0.2, 0), curve: Curves.easeOut),
                Center(
                  child: AppBtn.from(
                    expand: true,
                    text: "Add new patient",
                    onPressed: () =>
                        _handleOnConsultationAdd(context, _formKey),
                  ).animate().fadeIn(delay: t).move(
                        begin: Offset(0, 50),
                        duration: t,
                        curve: Curves.easeOutCubic,
                      ),
                )
              ],
            )),
      ],
    );
  }
}
