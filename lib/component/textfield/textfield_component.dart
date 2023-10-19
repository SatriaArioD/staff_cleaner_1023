import 'package:flutter/material.dart';

class TextfieldComponent extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Color color;
  final TextInputType inputType;
  final bool isRequired;
  final bool readOnly;

  const TextfieldComponent({
    super.key,
    this.hintText = "",
    this.onChanged,
    this.validator,
    this.controller,
    this.color = Colors.white70,
    this.inputType = TextInputType.text,
    this.isRequired = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      controller: controller,
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
      cursorColor: Colors.black,
      decoration: InputDecoration(
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
        fillColor: color,
      ),
      readOnly: readOnly,
    );
  }
}
