import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class FormTextField extends StatelessWidget {
  String? validationMessage;
  bool? showNumberKeyboardOnly;
  String? labelName;
  String? initialValue;
  bool? darkBackground;
  void Function(String?)? onSaved;

  FormTextField(
      {Key? key,
      this.labelName,
      this.validationMessage,
      this.onSaved,
      this.darkBackground,
      this.showNumberKeyboardOnly,
      this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Padding(
        padding: EdgeInsets.only(bottom: $styles.insets.sm),
        child: TextFormField(
          initialValue: initialValue,
          keyboardType: (showNumberKeyboardOnly ?? false)
              ? TextInputType.number
              : TextInputType.text,
          inputFormatters: (showNumberKeyboardOnly ?? false)
              ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
              : [],
          onSaved: onSaved,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 0.0),
            ),
            border: const OutlineInputBorder(),
            labelText: labelName,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validationMessage;
            }
            return null;
          },
        ),
      ),
    );
  }
}
