import 'package:flutter/material.dart';
import 'package:staff_cleaner/component/textfield/textfield_component.dart';
import 'package:staff_cleaner/values/widget_utils.dart';

class CustomPriceDialog extends StatefulWidget {
  final String title;

  const CustomPriceDialog({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<CustomPriceDialog> createState() => _CustomPriceDialogState();
}

class _CustomPriceDialogState extends State<CustomPriceDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController panjangController = TextEditingController();
  final TextEditingController lebarController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 300.0,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextfieldComponent(
                      hintText: "Panjang",
                      controller: panjangController,
                      inputType: TextInputType.number,
                      isRequired: true,
                    ),
                  ),
                  H(8),
                  Expanded(
                    child: TextfieldComponent(
                      hintText: "Lebar",
                      controller: lebarController,
                      inputType: TextInputType.number,
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              V(12),
              TextfieldComponent(
                hintText: "Harga",
                controller: hargaController,
                inputType: TextInputType.number,
                isRequired: true,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              Navigator.pop(context, {
                'panjang': int.parse(panjangController.text),
                'lebar': int.parse(lebarController.text),
                'harga': int.parse(hargaController.text),
              });
            }
          },
          child: const Text('Tambah'),
        ),
      ],
    );
  }
}
