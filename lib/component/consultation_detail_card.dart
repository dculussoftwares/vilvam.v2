import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_demo/component/info_row.dart';
import 'package:material_3_demo/component/themed_text.dart';
import 'package:material_3_demo/main.dart';
import 'package:material_3_demo/modal/Consultation.dart';
import 'package:material_3_demo/modal/PatientConsultation.dart';

class ConsultationDetail extends StatelessWidget {
  const ConsultationDetail(
      {Key? key, this.darkMode = false, required this.clinicConsultation})
      : super(key: key);

  final bool darkMode;
  final ClinicConsultation clinicConsultation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // context.push(ScreenPaths.patient(consultation!.id));
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
                    /// Text content
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...[
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                GoRouter.of(context).push(
                                    "/editConsultation/${clinicConsultation.consultation.id}");
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit'),
                            ),
                          ),
                          Gap($styles.insets.lg),
                          InfoRow(
                              "Notes:", clinicConsultation.consultation.notes),
                          InfoRow("Clinic name:",
                              clinicConsultation.clinicDetails.name),
                          InfoRow("Clinic location:",
                              clinicConsultation.clinicDetails.location),
                        ]
                            .animate(interval: 100.ms)
                            .fadeIn(delay: 600.ms, duration: $styles.times.med)
                            .slide(
                                begin: Offset(0.2, 0), curve: Curves.easeOut),
                      ],
                    )),
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
