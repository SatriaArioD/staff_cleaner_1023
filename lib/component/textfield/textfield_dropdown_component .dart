import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

class TextfieldDropdownComponent extends StatelessWidget {
  final String hintText;
  final Function(Object?)? onChanged;
  final String? Function(String?)? validator;
  final List<Map<dynamic, dynamic>>? items;
  final SingleValueDropDownController? controller;
  final bool isRequired;
  final bool readOnly;

  const TextfieldDropdownComponent({
    super.key,
    this.hintText = "",
    this.onChanged,
    this.validator,
    this.items,
    this.controller,
    this.isRequired = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: readOnly,
      child: DropDownTextField(
        onChanged: onChanged,
        validator: validator ??
            (isRequired
                ? (val) {
                    if (val?.isEmpty ?? true) {
                      return 'field ini tidak boleh kosong';
                    }
                    return null;
                  }
                : null),
        controller: controller,
        textFieldDecoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          hintText: hintText,
          fillColor: Colors.white,
        ),
        dropDownList: items!
            .map((e) => DropDownValueModel(
                value: e["value"], name: e["name"].toString()))
            .toList(),
      ),
    );
  }
}
