import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../main.dart';

class FailedToFetch extends StatelessWidget {
  const FailedToFetch({super.key});

  @override
  Widget build(BuildContext context) {
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
            "Failed to fetch",
            style: $styles.text.body.copyWith(color: $styles.colors.offWhite),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ).animate().fadeIn();
  }
}
