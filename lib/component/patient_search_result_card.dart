import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_demo/component/themed_text.dart';
import 'package:material_3_demo/main.dart';
import 'package:material_3_demo/modal/Patients.dart';

class PatientSearchResultCard extends StatelessWidget {
  const PatientSearchResultCard({super.key, required this.patients});

  final Patients? patients;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var patientId = patients?.id ?? "";
        GoRouter.of(context).push("/patientDetailPage/${patientId}");
        // openPatientDetailFullscreenDialog(context, patients!.id);
        // context.push(ScreenPaths.patient(patients!.id));
      },
      child: MergeSemantics(
        child: Padding(
          padding: EdgeInsets.only(bottom: $styles.insets.sm),
          child: DefaultTextColor(
            color: Colors.white,
            child: Container(
              color: $styles.colors.greyStrong,
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
                    Container(width: 1, color: Colors.white),

                    Gap($styles.insets.sm),

                    /// Text content
                    Expanded(
                      child: Column(
                        children: [
                          Focus(
                              child: Text(patients!.name,
                                  style: $styles.text.body)),

                          Focus(
                              child: Text(patients!.address.toString(),
                                  style: $styles.text.body)),
                          Focus(
                              child: Text(patients!.phoneNumber.toString(),
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
