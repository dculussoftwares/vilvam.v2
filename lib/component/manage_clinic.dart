import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_3_demo/main.dart';
import 'package:material_3_demo/modal/ClinicDetail.dart';
import 'package:material_3_demo/ui/failed_to_fetch.dart';

import '../ui/app_loading_indicator.dart';
import 'consultation_detail_card.dart';

class ManageClinic extends StatefulWidget {
  const ManageClinic({super.key});

  @override
  State<ManageClinic> createState() => _ManageClinicState();
}

class _ManageClinicState extends State<ManageClinic> {
  late final _future = dataRepository.getAllClinic();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<ClinicDetail>>(
          future: _future,
          builder: (_, snapshot) {
            final clinics = snapshot.data;

            late Widget content;
            if (snapshot.hasError || (snapshot.hasData && clinics == null)) {
              content = const FailedToFetch();
            } else if (!snapshot.hasData) {
              content = const Center(child: AppLoadingIndicator());
            } else {
              content = ListView.builder(
                  shrinkWrap: true,
                  itemCount: clinics?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final delay = 100.ms + (100 * clinics!.length).ms;
                    final patient = clinics.elementAt(index);
                    return ClinicDetailCard(
                            clinicDetails: clinics,
                            currentIndex: index,
                            darkMode: true)
                        .animate()
                        .fade(delay: delay, duration: $styles.times.med * 1.5)
                        .slide(begin: Offset(0, 1), curve: Curves.easeOutBack);
                  });
            }
            return Stack(
              children: [content],
            );
          },
        )
      ],
    );
  }
}
