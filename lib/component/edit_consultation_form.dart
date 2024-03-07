import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_demo/modal/Consultation.dart';
import 'package:material_3_demo/ui/app_loading_indicator.dart';
import 'package:material_3_demo/ui/buttons.dart';
import 'package:material_3_demo/ui/failed_to_fetch.dart';
import 'package:material_3_demo/ui/form_dropdown_field.dart';
import 'package:material_3_demo/ui/form_text_field.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import '../modal/ClinicDetail.dart';

class EditConsultationForm extends StatefulWidget {
  String? consultationId;

  EditConsultationForm({super.key, this.consultationId});

  @override
  State<EditConsultationForm> createState() => _EditConsultationForm();
}

class _EditConsultationForm extends State<EditConsultationForm> {
  final _formKey = GlobalKey<FormState>();
  String? notes;
  String? patientId;
  String? clinicId;

  var uuid = const Uuid();
  late final _consultationFuture =
      dataRepository.getConsultationById(widget.consultationId ?? "");
  late final _activeClinicFuture = dataRepository.getAllClinic();

  @override
  Widget build(BuildContext context) {
    Duration t = $styles.times.med;

    Future<void> _handleOnConsultationUpdate(
        BuildContext context, GlobalKey<FormState> formKey) async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        await dataRepository.addConsultation(Consultation(
            id: widget.consultationId ?? '',
            notes: notes ?? '',
            patientId: patientId ?? '',
            clinicId: clinicId ?? ''));
        if (context.mounted) {
          toastification.show(
            context: context,
            type: ToastificationType.success,
            title: const Text('Success!'),
            description: const Text('Updated consultation successfully'),
            autoCloseDuration: const Duration(seconds: 3),
          );
          GoRouter.of(context).go("/patientDetailPage/$patientId");
        }
      }
    }

    ;

    return FutureBuilder(
      future: Future.wait([_consultationFuture, _activeClinicFuture]),
      builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
        late Widget content;
        if (snapshot.hasError ||
            (snapshot.hasData && snapshot.data?[0] as Consultation == null)) {
          content = FailedToFetch();
        } else if (!snapshot.hasData) {
          content = const Center(child: AppLoadingIndicator());
        } else {
          final consultationData = snapshot.data?[0] as Consultation;
          final activeClinicsData = snapshot.data?[1] as List<ClinicDetail>;
          ClinicDetail? clinicDropdownInitialValue = activeClinicsData
              .where((element) => element.id == consultationData.clinicId)
              .first;
          patientId = consultationData.patientId;
          clinicId = clinicDropdownInitialValue?.id;
          content = Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...[
                    FormTextField(
                        initialValue: consultationData.notes,
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
                    options: activeClinicsData
                        .map<DropdownMenuItem<ClinicDetail>>(
                            (ClinicDetail clinicDetail) {
                      return DropdownMenuItem<ClinicDetail>(
                        value: clinicDetail,
                        child: Text(clinicDetail.name),
                      );
                    }).toList(),
                  ),
                  Center(
                    child: AppBtn.from(
                      expand: true,
                      text: "Update consultation",
                      onPressed: () =>
                          _handleOnConsultationUpdate(context, _formKey),
                    ).animate().fadeIn(delay: t).move(
                          begin: Offset(0, 50),
                          duration: t,
                          curve: Curves.easeOutCubic,
                        ),
                  )
                ],
              ));
        }
        return Stack(children: [
          content,
          // AppHeader(isTransparent: true),
        ]);
      },
    );
  }
}
