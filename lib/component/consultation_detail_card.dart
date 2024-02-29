import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_3_demo/component/themed_text.dart';
import 'package:material_3_demo/modal/ClinicDetail.dart';

import '../main.dart';

class ClinicDetailCard extends StatefulWidget {
  const ClinicDetailCard({
    Key? key,
    required this.clinicDetails,
    required this.currentIndex,
    this.darkMode = false,
  }) : super(key: key);

  final bool darkMode;
  final List<ClinicDetail> clinicDetails;
  final int currentIndex;

  @override
  State<ClinicDetailCard> createState() => _ClinicDetailCardState();
}

class _ClinicDetailCardState extends State<ClinicDetailCard> {
  // final bool useMaterial3;
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    isEnabled = widget.clinicDetails.elementAt(widget.currentIndex).isEnabled;
    //your code here
  }

  @override
  Widget build(BuildContext context) {
    // isEnabled = widget.consultation!.isEnabled;

    return GestureDetector(
      // onTap: () {
      //   context.push(ScreenPaths.patient(consultation!.id));
      // },
      child: MergeSemantics(
        child: Padding(
          padding: EdgeInsets.only(bottom: $styles.insets.sm),
          child: DefaultTextColor(
            color: widget.darkMode ? Colors.white : Colors.black,
            child: Container(
              color: widget.darkMode
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
                          Text('Status', style: $styles.text.bodySmall),
                          Switch(
                              value: isEnabled,
                              onChanged: (value) async {
                                setState(() {
                                  isEnabled = value;
                                });
                                var clinicDetail = widget.clinicDetails
                                    .elementAt(widget.currentIndex);
                                var updatedClinicDetail = ClinicDetail(
                                    id: clinicDetail.id,
                                    name: clinicDetail.name,
                                    location: clinicDetail.location,
                                    isEnabled: value);
                                await dataRepository
                                    .updateClinicStatus(updatedClinicDetail);
                                var a = await dataRepository.getAllClinic();
                                var xxx = 0;
                              }),
                        ],
                      ),
                    ),

                    /// Divider
                    Container(
                        width: 1,
                        color: widget.darkMode
                            ? Colors.white
                            : $styles.colors.black),

                    Gap($styles.insets.sm),

                    /// Text content
                    Expanded(
                      child: Column(
                        children: [
                          Focus(
                              child: Text(
                                  widget.clinicDetails
                                      .elementAt(widget.currentIndex)
                                      .name,
                                  style: $styles.text.body)),
                          Focus(
                              child: Text(
                                  widget.clinicDetails
                                      .elementAt(widget.currentIndex)
                                      .location,
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
