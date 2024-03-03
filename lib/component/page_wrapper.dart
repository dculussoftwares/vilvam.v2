import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  PageWrapper({super.key, required this.widget});

  Widget widget;

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
              body: Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_circle_left),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    ...[widget]
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
