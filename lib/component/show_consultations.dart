import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_3_demo/component/page_wrapper.dart';
import 'package:material_3_demo/main.dart';
import 'package:material_3_demo/modal/Consultation.dart';
import 'package:material_3_demo/ui/failed_to_fetch.dart';

import '../ui/app_loading_indicator.dart';
import 'consultation_detail_card.dart';

class ShowConsultation extends StatelessWidget {
  ShowConsultation({super.key, required this.patientId});

  String patientId;

  @override
  Widget build(BuildContext context) {
    late final _future =
        dataRepository.getAllConsultationByPatientId(patientId);
    return PageWrapper(
        child: Column(
      children: [
        Text("All consultations"),
        FutureBuilder<List<Consultation>>(
            future: _future,
            builder: (_, snapshot) {
              final consultation = snapshot.data;

              late Widget content;
              if (snapshot.hasError ||
                  (snapshot.hasData && consultation == null)) {
                content = const FailedToFetch();
              } else if (!snapshot.hasData) {
                content = const Center(child: AppLoadingIndicator());
              } else {
                content = ListView.builder(
                    shrinkWrap: true,
                    itemCount: consultation?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final delay = 100.ms + (100 * consultation!.length).ms;
                      final patient = consultation.elementAt(index);
                      return ConsultationDetail(
                              consultation: patient, darkMode: true)
                          .animate()
                          .fade(delay: delay, duration: $styles.times.med * 1.5)
                          .slide(
                              begin: Offset(0, 1), curve: Curves.easeOutBack);
                    });
              }
              return Stack(
                children: [content],
              );
            })
      ],
    ));
  }
}
