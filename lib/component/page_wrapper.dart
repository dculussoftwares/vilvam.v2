import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

class PageWrapper extends StatelessWidget {
  PageWrapper({super.key, required this.child});

  Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(color: colorScheme.surface),
        child: Align(
            alignment: Alignment.topLeft,
            // widthFactor: widthAnimation.value,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  // padding: const EdgeInsets.symmetric(vertical: 20.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gap($styles.insets.sm),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton.icon(
                            label: const Text('Back'),
                            icon: const Icon(
                              Icons.chevron_left_sharp,
                              size: 24.0,
                            ),
                            onPressed: () => {Navigator.pop(context)},
                          ),
                        ],
                      ),
                      Gap($styles.insets.sm),
                      ...[child]
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
