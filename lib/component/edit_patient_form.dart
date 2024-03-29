import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_demo/modal/Gender.dart';
import 'package:material_3_demo/modal/Patients.dart';
import 'package:material_3_demo/ui/app_loading_indicator.dart';
import 'package:material_3_demo/ui/buttons.dart';
import 'package:material_3_demo/ui/failed_to_fetch.dart';
import 'package:material_3_demo/ui/form_dropdown_field.dart';
import 'package:material_3_demo/ui/form_text_field.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

class EditPatientForm extends StatefulWidget {
  String? patientId;
  bool? isEdit = false;

  EditPatientForm({super.key, this.patientId, this.isEdit});

  @override
  State<EditPatientForm> createState() => _EditPatientForm();
}

class _EditPatientForm extends State<EditPatientForm> {
  static final _formKey = GlobalKey<FormState>();
  String? name;
  String? age;
  String? phoneNumber;
  String? address;
  String? gender = 'male';
  var uuid = const Uuid();
  late final _future = dataRepository.getPatientById(widget.patientId ?? "");

  @override
  Widget build(BuildContext context) {
    Duration t = $styles.times.med;
    Color backColor = $styles.colors.black;

    List<Gender> genderList = <Gender>[
      Gender(key: 'male', value: "Male"),
      Gender(key: 'female', value: "Female"),
      Gender(key: 'trans_gender', value: "Trans gender"),
      Gender(key: 'other_gender', value: "Other gender"),
    ];

    return FutureBuilder<Patients?>(
      future: _future,
      builder: (_, snapshot) {
        final data = snapshot.data;

        late Widget content;
        if (snapshot.hasError || (snapshot.hasData && data == null)) {
          content = FailedToFetch();
        } else if (!snapshot.hasData) {
          content = const Center(child: AppLoadingIndicator());
        } else {
          Gender genderDropdownValue =
              genderList.where((e) => e.key == data?.gender).first;
          content = Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gap($styles.insets.lg),
                    Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...[
                              FormTextField(
                                  initialValue: data?.name,
                                  labelName: "Name",
                                  validationMessage: "Name is required",
                                  onSaved: (value) {
                                    print("NAMMMEMEEE");
                                    name = value;
                                  }),
                              FormTextField(
                                  initialValue: data?.age.toString(),
                                  showNumberKeyboardOnly: true,
                                  labelName: "Age",
                                  validationMessage: "Age is required",
                                  onSaved: (value) {
                                    print("AGEEEEE");
                                    age = value;
                                  }),
                              FormTextField(
                                  initialValue: data?.phoneNumber.toString(),
                                  showNumberKeyboardOnly: true,
                                  labelName: "Phone number",
                                  validationMessage: "Phone number is required",
                                  onSaved: (value) {
                                    phoneNumber = value;
                                  }),
                              FormFieldDropdown<Gender>(
                                onChanged: (Gender? value) {
                                  gender = value?.key;
                                },
                                labelName: "Gender",
                                initialValue: genderDropdownValue,
                                validator: (value) {
                                  if (value == null || value.key.isEmpty) {
                                    return "Gender is required";
                                  }
                                  return null;
                                },
                                options: genderList
                                    .map<DropdownMenuItem<Gender>>(
                                        (Gender gender) {
                                  return DropdownMenuItem<Gender>(
                                    value: gender,
                                    child: Text(gender.value),
                                  );
                                }).toList(),
                              ),
                              FormTextField(
                                  initialValue: data?.address,
                                  labelName: "Address",
                                  validationMessage: "Address is required",
                                  onSaved: (value) {
                                    print("ADDRESSS");
                                    address = value;
                                  }),
                            ]
                                .animate(interval: 100.ms)
                                .fadeIn(
                                    delay: 600.ms, duration: $styles.times.med)
                                .slide(
                                    begin: Offset(0.2, 0),
                                    curve: Curves.easeOut),
                            Center(
                              child: AppBtn.from(
                                expand: true,
                                text: "Update patient",
                                onPressed: () =>
                                    _handleOnPatientAdd(context, _formKey),
                              ).animate().fadeIn(delay: t).move(
                                    begin: Offset(0, 50),
                                    duration: t,
                                    curve: Curves.easeOutCubic,
                                  ),
                            ),
                          ],
                        )),
                    Gap($styles.insets.lg),
                  ],
                ),
              )
            ],
          );
        }
        return Stack(children: [
          content,
          // AppHeader(isTransparent: true),
        ]);
      },
    );
  }

  Future<void> _handleOnPatientAdd(
      BuildContext context, GlobalKey<FormState> formKey) async {
    print("CLIKED");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("Validated");
      // print("Validated"+_formKey.currentState!.);
      print('name ${name!}');
      print('address ${address!}');
      print('age ${age!}');
      var newPatientId = uuid.v4().toString();
      await dataRepository.addPatient(Patients(
          id: newPatientId,
          name: name!,
          age: int.parse(age!),
          phoneNumber: int.parse(phoneNumber!),
          address: address!,
          gender: gender!));
      if (context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          title: const Text('Success!'),
          description: const Text('Updated patient successfully'),
          autoCloseDuration: const Duration(seconds: 3),
        );
        GoRouter.of(context).go("/patientDetailPage/$newPatientId");
      }
    }
    print("CLIKED+++");

    // Navigator.of(context).pop();
    // Navigator.pop(context);
    // context.push(ScreenPaths.collection("collectible.id"));
  }
}
