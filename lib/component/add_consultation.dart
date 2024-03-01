import 'package:flutter/material.dart';
import 'package:material_3_demo/typography_screen.dart';

class AddConsultation extends StatelessWidget {
  const AddConsultation({super.key});

  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    var patientId = routes["patientId"] as String;
    return TypographyScreen();

  }
}
