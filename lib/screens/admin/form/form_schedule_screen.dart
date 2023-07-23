import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:staff_cleaner/component/button/button_component.dart';
import 'package:staff_cleaner/component/text/text_component.dart';
import 'package:staff_cleaner/component/textfield/textfield_date_component.dart';
import 'package:staff_cleaner/component/textfield/textfield_dropdown_component%20.dart';
import 'package:staff_cleaner/values/color.dart';
import 'package:staff_cleaner/values/font_custom.dart';
import 'package:staff_cleaner/values/screen_utils.dart';
import 'package:staff_cleaner/values/widget_utils.dart';

class FormScheduleScreen extends StatefulWidget {
  const FormScheduleScreen({Key? key}) : super(key: key);

  @override
  State<FormScheduleScreen> createState() => _FormScheduleScreenState();
}

class _FormScheduleScreenState extends State<FormScheduleScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final SingleValueDropDownController customerNameController =
      SingleValueDropDownController();
  final SingleValueDropDownController customerAddressController =
      SingleValueDropDownController();
  final TextEditingController serviceDateController = TextEditingController();
  final TextEditingController serviceTimeController = TextEditingController();
  final List<TextEditingController> itemsController = [TextEditingController()];
  final List<SingleValueDropDownController> staffsController = [
    SingleValueDropDownController()
  ];

  // todo: selected customer with selected address
  // todo: list item
  List<Map<dynamic, dynamic>> itemYangDibersihkan = [];

  // todo: list staff

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.0.w,
        height: 1.0.h,
        color: primaryColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextComponent(
                  "Input Jadwal",
                  color: Colors.white,
                ),
                V(32),
                TextfieldDropdownComponent(
                  hintText: "Nama customer...",
                  onChanged: (value) {},
                  items: List.generate(
                      5,
                      (index) => {
                            "name": 'customer $index',
                            "value": 'email $index'
                          }).toList(),
                  controller: customerNameController,
                ),
                V(16),
                TextfieldDropdownComponent(
                  hintText: "Alamat",
                  items: List.generate(
                      5,
                      (index) => {
                            "name": 'address $index',
                            "value": 'email $index'
                          }).toList(),
                  controller: customerAddressController,
                ),
                V(16),
                TextfieldDateComponent(
                  hintText: "Tanggal layanan",
                  onChanged: (value) {},
                  color: Colors.white,
                  controller: serviceDateController,
                ),
                V(16),
                TextfieldDateComponent(
                  hintText: "Jam layanan",
                  onChanged: (value) {},
                  color: Colors.white,
                  controller: serviceTimeController,
                  type: 'time',
                ),
                V(16),
                const TextComponent(
                  "Item yang akan di bersihkan: ",
                  size: 18,
                  color: Colors.white,
                ),
                V(8),
                Column(
                  children: itemYangDibersihkan
                      .asMap()
                      .map(
                        (i, e) => MapEntry(
                          i,
                          Stack(
                            children: [
                              Column(
                                children: [
                                  Card(
                                    elevation: 8,
                                    clipBehavior: Clip.hardEdge,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextComponent(
                                            "${i + 1}. [${e["service"]}] ${e["item"]}",
                                            size: 10,
                                            weight: Lato.Light,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                itemYangDibersihkan.removeAt(i);
                                              });
                                            },
                                            icon: const Icon(Icons.remove),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  V(8)
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                      .values
                      .toList(),
                ),
                V(24),
                ...List.generate(
                  staffsController.length,
                  (index) => Container(
                    margin: EdgeInsets.only(top: index == 0 ? 0 : 16),
                    child: TextfieldDropdownComponent(
                      hintText: "Pilih Staf yang akan melayani",
                      onChanged: (value) {},
                      items: List.generate(
                          5,
                          (index) => {
                                "name": 'staff $index',
                                "value": 'email $index'
                              }).toList(),
                      controller: staffsController[index],
                    ),
                  ),
                ),
                V(16),
                Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 16,
                  spacing: 16,
                  children: [
                    ButtonElevatedComponent(
                      "Tambah Staff",
                      onPressed: () {
                        setState(() {
                          staffsController.add(SingleValueDropDownController());
                        });
                      },
                    ),
                    if (staffsController.length > 1) ...[
                      ButtonElevatedComponent(
                        "Hapus Staff",
                        onPressed: () {
                          setState(() {
                            staffsController.removeLast();
                          });
                        },
                      )
                    ],
                  ],
                ),
                V(48),
                ButtonElevatedComponent(
                  "Simpan",
                  onPressed: () {
                    // todo: save data customer
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
