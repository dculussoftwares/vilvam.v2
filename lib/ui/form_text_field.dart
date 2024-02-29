import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class FormTextField extends StatelessWidget {
  String? validationMessage;
  bool? showNumberKeyboardOnly;
  String? labelName;
  bool? darkBackground;
  void Function(String?)? onSaved;

  FormTextField(
      {Key? key,
      this.labelName,
      this.validationMessage,
      this.onSaved,
      this.darkBackground,
      this.showNumberKeyboardOnly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Padding(
        padding: EdgeInsets.only(bottom: $styles.insets.sm),
        child: TextFormField(
          keyboardType: (showNumberKeyboardOnly ?? false)
              ? TextInputType.number
              : TextInputType.text,
          inputFormatters: (showNumberKeyboardOnly ?? false)
              ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
              : [],
          style:
              (darkBackground ?? false) ? TextStyle(color: Colors.white) : null,
          onSaved: onSaved,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.black),
            labelStyle: TextStyle(color: $styles.colors.accent1),
            enabledBorder: OutlineInputBorder(
              borderSide: (darkBackground ?? false)
                  ? BorderSide(color: Colors.white, width: 0.0)
                  : BorderSide(color: Colors.black, width: 0.0),
            ),
            border: OutlineInputBorder(),
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
