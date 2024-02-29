import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_3_demo/component/themed_text.dart';
import 'package:material_3_demo/main.dart';
import 'package:material_3_demo/modal/Patients.dart';

class PatientCard extends StatelessWidget {
  const PatientCard(
      {Key? key,
      required this.year,
      required this.text,
      required this.patients,
      this.darkMode = false})
      : super(key: key);
  final int year;
  final String text;
  final bool darkMode;
  final Patients? patients;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // context.push(ScreenPaths.patient(patients!.id));
      },
      child: MergeSemantics(
        child: Padding(
          padding: EdgeInsets.only(bottom: $styles.insets.sm),
          child: DefaultTextColor(
            color: darkMode ? Colors.white : Colors.black,
            child: Container(
              color: darkMode
                  ? $styles.colors.greyStrong
                  : $styles.colors.offWhite,
              padding: EdgeInsets.all($styles.insets.sm),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    /// Date
                    SizedBox(
                      width: 75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(patients!.age.toString(),
                              style: $styles.text.h3.copyWith(
                                  fontWeight: FontWeight.w400, height: 1)),
                          Text('Age', style: $styles.text.bodySmall),
                        ],
                      ),
                    ),

                    /// Divider
                    Container(
                        width: 1,
                        color: darkMode ? Colors.white : $styles.colors.black),

                    Gap($styles.insets.sm),

                    /// Text content
                    Expanded(
                      child: Column(
                        children: [
                          Focus(
                              child: Text(patients!.name,
                                  style: $styles.text.body)),
                          Focus(
                              child: Text(patients!.age.toString(),
                                  style: $styles.text.body)),
                          Focus(
                              child: Text(patients!.address.toString(),
                                  style: $styles.text.body)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
