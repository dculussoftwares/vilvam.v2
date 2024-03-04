import 'package:flutter/material.dart';
import 'package:material_3_demo/main.dart';

class FormFieldDropdown<T extends Object> extends StatelessWidget {
  String? labelName;
  void Function(T?)? onSaved;
  bool? darkBackground;
  FormFieldValidator<T>? validator;
  T? initialValue;
  List<DropdownMenuItem<T>>? options;
  void Function(T?)? onChanged;

  FormFieldDropdown(
      {Key? key,
      this.labelName,
      this.onSaved,
      this.darkBackground,
      this.validator,
      this.initialValue,
      this.options,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
        child: Padding(
            padding: EdgeInsets.only(bottom: $styles.insets.sm),
            child: DropdownButtonFormField<T>(
                style: (darkBackground ?? false)
                    ? TextStyle(color: Colors.white)
                    : null,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.0),
                  ),
                  border: OutlineInputBorder(),
                  labelText: labelName,
                ),
                validator: validator,
                value: initialValue,
                items: options,
                onChanged: (T? value) {
                  onChanged!(value);
                }))

        // TextFormField(
        //   style:
        //   (darkBackground ?? false) ? TextStyle(color: Colors.white) : null,
        //   onSaved: onSaved,
        //   decoration: InputDecoration(
        //     hintStyle: TextStyle(color: Colors.black),
        //     labelStyle: TextStyle(color: $styles.colors.accent1),
        //     enabledBorder: OutlineInputBorder(
        //       borderSide: (darkBackground ?? false)
        //           ? BorderSide(color: Colors.white, width: 0.0)
        //           : BorderSide(color: Colors.black, width: 0.0),
        //     ),
        //     border: OutlineInputBorder(),
        //     labelText: labelName,
        //   ),
        //   validator: (value) {
        //     if (value == null || value.isEmpty) {
        //       return validationMessage;
        //     }
        //     return null;
        //   },
        // ),
        // Text("")),
        );
  }
}

/*
*
*
* DropdownButtonFormField<T>(
            validator: validator,
            value: initialValue,
            items:options,
            onChanged: (T? value) {
onChanged!(value)
            }))
* */
