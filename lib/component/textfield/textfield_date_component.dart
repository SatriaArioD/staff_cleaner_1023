import 'package:flutter/material.dart';

class TextfieldDateComponent extends StatefulWidget {
  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Color color;
  final String type;
  final bool isRequired;

  const TextfieldDateComponent({
    super.key,
    this.hintText = "",
    this.onChanged,
    this.validator,
    this.controller,
    this.color = Colors.white70,
    this.type = "date",
    this.isRequired = false,
  });

  @override
  State<TextfieldDateComponent> createState() => _TextfieldDateComponentState();
}

class _TextfieldDateComponentState extends State<TextfieldDateComponent> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      onChanged: widget.onChanged,
      validator: widget.validator ??
          (widget.isRequired
              ? (val) {
                  if (val?.isEmpty ?? true) {
                    return 'field ini tidak boleh kosong';
                  }
                  return null;
                }
              : null),
      controller: widget.controller,
      cursorColor: Colors.black,
      readOnly: true,
      decoration: InputDecoration(
        suffixIcon: widget.type == "date"
            ? IconButton(
                icon: Icon(
                  Icons.date_range,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  showDatePickerDialog();
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.lock_clock,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  showTimePickerDialog();
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
        fillColor: widget.color,
      ),
      onTap: () {
        if (widget.type == 'date') {
          showDatePickerDialog();
        } else {
          showTimePickerDialog();
        }
      },
    );
  }

  void showDatePickerDialog() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2099),
    ).then((date) {
      //tambahkan setState dan panggil variabel _dateTime.
      setState(() {
        widget.controller?.text = "${date?.day}/${date?.month}/${date?.year}";
      });
    });
  }

  void showTimePickerDialog() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((time) {
      //tambahkan setState dan panggil variabel _dateTime.
      setState(() {
        widget.controller?.text = "${time?.hour}:${time?.minute}";
      });
    });
  }
}
