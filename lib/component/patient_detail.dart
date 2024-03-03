import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:material_3_demo/component/_patient_action.dart';
import 'package:material_3_demo/main.dart';
import 'package:material_3_demo/modal/Patients.dart';

import '../ui/app_loading_indicator.dart';

class PatientDetailScreen extends StatefulWidget {
  PatientDetailScreen({super.key, required this.patientId});

  String patientId;

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late final _future = dataRepository.getPatientById(widget.patientId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Patients?>(
      future: _future,
      builder: (_, snapshot) {
        final data = snapshot.data;
        late Widget content;
        if (snapshot.hasError || (snapshot.hasData && data == null)) {
          content = _buildError();
        } else if (!snapshot.hasData) {
          content = const Center(child: AppLoadingIndicator());
        } else {
          content = Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                  child: Column(
                children: [
                  PatientAction(patientId: widget.patientId),
                  PatientDetailTableColumn(data: data)
                ],
              ))
            ],
          );
        }
        return Stack(children: [
          content,
          // AppHeader(isTransparent: true),
        ]);
      },
    );
    // return Text("Ommm");
  }

  Animate _buildError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Icon(
          Icons.warning_amber_outlined,
          color: $styles.colors.accent1,
          size: $styles.insets.lg,
        )),
        Gap($styles.insets.xs),
        SizedBox(
          width: $styles.insets.xxl * 3,
          child: Text(
            "Unable to find info for artifact",
            style: $styles.text.body.copyWith(color: $styles.colors.offWhite),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ).animate().fadeIn();
  }
}

class PatientDetailTableColumn extends StatelessWidget {
  PatientDetailTableColumn({Key? key, required this.data}) : super(key: key);
  final Patients? data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gap($styles.insets.xl),
          // if (data!.name.isNotEmpty) ...[
          //   Text(
          //     data!.name.toUpperCase(),
          //     style: $styles.text.titleFont
          //         .copyWith(color: $styles.colors.accent1),
          //   ).animate().fade(delay: 150.ms, duration: 600.ms),
          //   Gap($styles.insets.xs),
          // ],
          Semantics(
            header: true,
            child: Text(
              data!.name,
              textAlign: TextAlign.center,
              style: $styles.text.h2
                  .copyWith(color: $styles.colors.offWhite, height: 1.2),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ).animate().fade(delay: 250.ms, duration: 600.ms),
          ),
          Gap($styles.insets.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[
                _InfoRow("Name", data!.name),
                _InfoRow("Address", data!.address),
                _InfoRow("Id", data!.id.toString()),
                _InfoRow("Age", data!.age.toString()),
              ]
                  .animate(interval: 100.ms)
                  .fadeIn(delay: 600.ms, duration: $styles.times.med)
                  .slide(begin: Offset(0.2, 0), curve: Curves.easeOut),
            ],
          ),
          Gap($styles.insets.md),
          Text(
            "The Metropolitan Museum of Art, New York",
            style: $styles.text.caption.copyWith(color: $styles.colors.accent2),
          )
              .animate(delay: 1.5.seconds)
              .fadeIn()
              .slide(begin: Offset(0.2, 0), curve: Curves.easeOut),
          Gap($styles.insets.offset),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  _InfoRow(this.label, this.value, {Key? key}) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      excluding: value.isEmpty,
      child: MergeSemantics(
        child: Padding(
          padding: EdgeInsets.only(bottom: $styles.insets.sm),
          child: Row(children: [
            Expanded(
              flex: 40,
              child: Text(
                label.toUpperCase(),
              ),
            ),
            Expanded(
              flex: 60,
              child: Text(
                value.isEmpty ? '--' : value,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
