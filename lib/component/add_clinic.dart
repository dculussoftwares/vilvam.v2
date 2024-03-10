import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:toastification/toastification.dart';
import 'package:gap/gap.dart';
import 'package:material_3_demo/modal/ClinicDetail.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import '../ui/buttons.dart';
import '../ui/form_text_field.dart';

class AddClinicForm extends StatefulWidget {
  const AddClinicForm({super.key});

  @override
  State<AddClinicForm> createState() => _AddClinicFormState();
}

class _AddClinicFormState extends State<AddClinicForm> {
  var uuid = const Uuid();
  static final _formKey = GlobalKey<FormState>();
  String? name;
  String? location;
  Duration t = $styles.times.med;

  Future<void> _handleOnClinicAdd(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await dataRepository.addClinic(ClinicDetail(
          id: uuid.v4().toString(),
          name: name ?? "",
          location: location ?? "",
          isEnabled: true));

      if (context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          title: const Text('Success!'),
          description: const Text('New clinic added successfully'),
          autoCloseDuration: const Duration(seconds: 3),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormTextField(
                    labelName: "Name",
                    validationMessage: "Name is required",
                    onSaved: (value) {
                      name = value;
                    }),
                FormTextField(
                    labelName: "Location",
                    validationMessage: "Location is required",
                    onSaved: (value) {
                      location = value;
                    }),
                Gap($styles.insets.lg),
                AppBtn.from(
                  text: "Add new clinic",
                  onPressed: () {
                    _handleOnClinicAdd(context, _formKey);
                  },
                ).animate().fadeIn(delay: t).move(
                      begin: const Offset(0, 50),
                      duration: t,
                      curve: Curves.easeOutCubic,
                    )
              ],
            ))
      ],
    );
  }
}
