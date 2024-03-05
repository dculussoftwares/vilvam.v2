import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_demo/component/gradient_container.dart';
import 'package:material_3_demo/main.dart';
import 'package:material_3_demo/ui/buttons.dart';

class PatientAction extends StatefulWidget {
  PatientAction({
    Key? key,
    required this.patientId,
  }) : super(key: key);
  String patientId;

  @override
  State<PatientAction> createState() => _PatientActionState();
}

class _PatientActionState extends State<PatientAction> {
  @override
  Widget build(BuildContext context) {
    Duration t = $styles.times.med;
    return Stack(
      children: [
        BottomCenter(
          child: Transform.translate(
            offset: Offset(0, $styles.insets.xl - 1),
            child: VtGradient(
              [
                $styles.colors.greyStrong,
                $styles.colors.greyStrong.withOpacity(0)
              ],
              const [0, 1],
              height: $styles.insets.xl,
            ),
          ),
        ),
        Container(
          color: $styles.colors.black,
          alignment: Alignment.center,
          child: SafeArea(
            bottom: false,
            minimum: EdgeInsets.symmetric(vertical: $styles.insets.sm),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppBtn.from(
                    text: "Add consultation",
                    isSecondary: true,
                    onPressed: () => {
                      GoRouter.of(context).push("/addConsultation/${widget.patientId}")
                      // Navigator.pushNamed(context, '/addConsultation',
                      //     arguments: {
                      //       'patientId': widget.patientId,
                      //     })
                      // context.push(ScreenPaths.addConsultation(
                      //     int.parse(widget.patientId)))
                    },
                  ).animate().fadeIn(delay: t).move(
                        begin: Offset(0, 50),
                        duration: t,
                        curve: Curves.easeOutCubic,
                      ),
                  Gap($styles.insets.xs),
                  AppBtn.from(
                    text: "Show consultations",
                    onPressed: () => {
                      GoRouter.of(context).push("/showConsultation/${widget.patientId}")
                      // context.push(ScreenPaths.allConsultation(
                      //     int.parse(widget.patientId)))
                    },
                  ).animate().fadeIn(delay: t).move(
                        begin: Offset(0, 50),
                        duration: t,
                        curve: Curves.easeOutCubic,
                      ),
                  Gap($styles.insets.xs),
                  // AppBtn.from(
                  //     text: $strings.appModalsButtonCancel,
                  //     expand: true,
                  //     onPressed: () => Navigator.of(context).pop(false)),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
