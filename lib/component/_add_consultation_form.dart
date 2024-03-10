import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_demo/main.dart';
import 'package:material_3_demo/modal/ClinicDetail.dart';
import 'package:material_3_demo/modal/Consultation.dart';
import 'package:material_3_demo/ui/buttons.dart';
import 'package:material_3_demo/ui/form_text_field.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../ui/app_loading_indicator.dart';
import '../ui/failed_to_fetch.dart';
import '../ui/form_dropdown_field.dart';

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
  static final _formKey = GlobalKey<FormState>();
  String? notes;
  String? clinicId;

  Future<void> _handleOnConsultationAdd(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var uuid = const Uuid();
      await dataRepository.addConsultation(Consultation(
          id: uuid.v4().toString(),
          notes: notes ?? '',
          patientId: widget.patientId,
          clinicId: clinicId ?? ''));
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
    }
  }

  late final _future = dataRepository.getAllActiveClinic();

  @override
  Widget build(BuildContext context) {
    Duration t = $styles.times.med;
    return Column(
      children: [
        FutureBuilder<List<ClinicDetail>>(
          future: _future,
          builder: (_, snapshot) {
            final clinics = snapshot.data;

            late Widget content;
            if (snapshot.hasError || (snapshot.hasData && clinics == null)) {
              content = const FailedToFetch();
            } else if (!snapshot.hasData) {
              content = const Center(child: AppLoadingIndicator());
            } else {
              ClinicDetail? clinicDropdownInitialValue = clinics?.first;
              clinicId = clinicDropdownInitialValue?.id;
              content = Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...[
                        FormTextField(
                            labelName: "Notes",
                            validationMessage: "Notes is required",
                            onSaved: (value) {
                              notes = value;
                            }),
                      ]
                          .animate(interval: 100.ms)
                          .fadeIn(delay: 600.ms, duration: $styles.times.med)
                          .slide(begin: Offset(0.2, 0), curve: Curves.easeOut),
                      FormFieldDropdown<ClinicDetail>(
                        onChanged: (ClinicDetail? value) {
                          clinicId = value?.id;
                        },
                        labelName: "Clinic",
                        initialValue: clinicDropdownInitialValue,
                        validator: (value) {
                          if (value == null) {
                            return "Clinic is required";
                          }
                          return null;
                        },
                        options: clinics?.map<DropdownMenuItem<ClinicDetail>>(
                            (ClinicDetail clinicDetail) {
                          return DropdownMenuItem<ClinicDetail>(
                            value: clinicDetail,
                            child: Text(clinicDetail.name),
                          );
                        }).toList(),
                      ),
                      Center(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              GoRouter.of(context).push("/addClinicPage");
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add new clinic'),
                          ),
                        ),
                      ),
                      Center(
                        child: AppBtn.from(
                          expand: true,
                          text: "Add new consultation",
                          onPressed: () =>
                              _handleOnConsultationAdd(context, _formKey),
                        ).animate().fadeIn(delay: t).move(
                              begin: Offset(0, 50),
                              duration: t,
                              curve: Curves.easeOutCubic,
                            ),
                      )
                    ],
                  ));
            }
            return Stack(
              children: [content],
            );
          },
        ),
      ],
    );
  }
}
