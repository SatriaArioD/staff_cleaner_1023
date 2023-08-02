import 'package:flutter/material.dart';

class TextfieldPasswordComponent extends StatefulWidget {
  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool isRequired;

  const TextfieldPasswordComponent({
    super.key,
    this.hintText = "",
    this.onChanged,
    this.validator,
    this.controller,
    this.isRequired = false,
  });

  @override
  State<TextfieldPasswordComponent> createState() =>
      _TextfieldPasswordComponentState();
}

class _TextfieldPasswordComponentState
    extends State<TextfieldPasswordComponent> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      controller: widget.controller,
      cursorColor: Colors.black,
      obscureText: !_passwordVisible,
      validator: widget.validator ??
          (widget.isRequired
              ? (val) {
                  if (val?.isEmpty ?? true) {
                    return 'field ini tidak boleh kosong';
                  }
                  return null;
                }
              : null),
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          hintText: widget.hintText,
          fillColor: Colors.white70),
    );
  }
}
