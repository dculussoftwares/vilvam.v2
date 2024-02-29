import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:material_3_demo/modal/Gender.dart';
import 'package:material_3_demo/modal/Patients.dart';
import 'package:material_3_demo/ui/buttons.dart';
import 'package:material_3_demo/ui/form_dropdown_field.dart';
import 'package:material_3_demo/ui/form_text_field.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

class AddPatientForm extends StatefulWidget {
  const AddPatientForm({Key? key}) : super(key: key);

  @override
  State<AddPatientForm> createState() => _AddPatientFormState();
}

class _AddPatientFormState extends State<AddPatientForm> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? age;
  String? address;
  String? gender = 'male';
  var uuid = const Uuid();

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
    Gender genderDropdownValue = genderList.first;
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                      labelName: "Name",
                      validationMessage: "Name is required",
                      onSaved: (value) {
                        print("NAMMMEMEEE");
                        name = value;
                      }),
                  FormTextField(
                      showNumberKeyboardOnly: true,
                      labelName: "Age",
                      validationMessage: "Age is required",
                      onSaved: (value) {
                        print("AGEEEEE");
                        age = value;
                      }),
                  // DropdownButtonFormField<Gender>(
                  //     validator: (value) {
                  //       if (value == null || value.key.isEmpty) {
                  //         return $strings.gender_required_error;
                  //       }
                  //       return null;
                  //     },
                  //     value: genderDropdownValue,
                  //     items: genderList
                  //         .map<DropdownMenuItem<Gender>>((Gender gender) {
                  //       return DropdownMenuItem<Gender>(
                  //         value: gender,
                  //         child: Text(gender.value),
                  //       );
                  //     }).toList(),
                  //     onChanged: (Gender? value) {
                  //       gender = value?.key;
                  //     }),
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
                        .map<DropdownMenuItem<Gender>>((Gender gender) {
                      return DropdownMenuItem<Gender>(
                        value: gender,
                        child: Text(gender.value),
                      );
                    }).toList(),
                  ),
                  FormTextField(
                      labelName: "Address",
                      validationMessage: "Address is required",
                      onSaved: (value) {
                        print("ADDRESSS");
                        address = value;
                      }),
                ]
                    .animate(interval: 100.ms)
                    .fadeIn(delay: 600.ms, duration: $styles.times.med)
                    .slide(begin: Offset(0.2, 0), curve: Curves.easeOut),
                Center(
                  child: AppBtn.from(
                    expand: true,
                    text: "Add new patient",
                    onPressed: () => _handleOnPatientAdd(context, _formKey),
                  ).animate().fadeIn(delay: t).move(
                        begin: Offset(0, 50),
                        duration: t,
                        curve: Curves.easeOutCubic,
                      ),
                ),
              ],
            )),
        // Animate().toggle(
        //     delay: 500.ms,
        //     builder: (_, value, __) {
        //       return CompassDivider(
        //           isExpanded: !value, duration: $styles.times.med);
        //     }),
        Gap($styles.insets.lg),
        // AppBtn.from(
        //   text: $strings.collectibleFoundButtonViewCollection,
        //   isSecondary: true,
        //   onPressed: () => _handleViewCollectionPressed(context),
        // ).animate().fadeIn(delay: t).move(
        //       begin: Offset(0, 50),
        //       duration: t,
        //       curve: Curves.easeOutCubic,
        //     ),
      ],
    );
  }

  void _handleViewCollectionPressed(BuildContext context) {
    // Navigator.pop(context);
    // context.push(ScreenPaths.collection("collectible.id"));
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
    }
    print("CLIKED+++");

    await dataRepository.addPatient(Patients(
        id: uuid.v4().toString(),
        name: name!,
        age: int.parse(age!),
        address: address!,
        gender: gender!));
    if (context.mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        title: const Text('Success!'),
        description: const Text('Added patient successfully'),
        autoCloseDuration: const Duration(seconds: 3),
      );
      Navigator.pop(context);
    }
    // Navigator.of(context).pop();
    // Navigator.pop(context);
    // context.push(ScreenPaths.collection("collectible.id"));
  }
}
