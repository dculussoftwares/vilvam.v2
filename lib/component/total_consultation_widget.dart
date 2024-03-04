import 'package:flutter/material.dart';

import '../constants.dart';
import '../main.dart';
import '../ui/app_loading_indicator.dart';

class TotalConsultation extends StatefulWidget {
  String patientId;

  TotalConsultation({super.key, required this.patientId});

  @override
  State<TotalConsultation> createState() => _TotalConsultationState();
}

class _TotalConsultationState extends State<TotalConsultation> {
  late final _future =
      dataRepository.totalConsultationCountByPatient(widget.patientId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
        future: _future,
        builder: (_, snapshot) {
          final data = snapshot.data;
          late Widget content;
          if (snapshot.hasError || (snapshot.hasData && data == null)) {
            content = GenericError();
          } else if (!snapshot.hasData) {
            content = const Center(child: AppLoadingIndicator());
          } else {
            content = Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Text("Total consulation count: " + data.toString())
                  ],
                ))
              ],
            );
          }
          return Stack(children: [
            content,
            // AppHeader(isTransparent: true),
          ]);
        });
  }
}
