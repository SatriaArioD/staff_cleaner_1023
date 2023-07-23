import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_cleaner/component/button/button_component.dart';
import 'package:staff_cleaner/component/text/text_component.dart';
import 'package:staff_cleaner/component/textfield/textfield_date_component.dart';
import 'package:staff_cleaner/component/textfield/textfield_dropdown_component%20.dart';
import 'package:staff_cleaner/cubit/customer_cubit.dart';
import 'package:staff_cleaner/cubit/staff_cubit.dart';
import 'package:staff_cleaner/models/address_model.dart';
import 'package:staff_cleaner/models/customer_model.dart';
import 'package:staff_cleaner/models/schedule_model.dart';
import 'package:staff_cleaner/models/staff_model.dart';
import 'package:staff_cleaner/services/schedule_service.dart';
import 'package:staff_cleaner/values/color.dart';
import 'package:staff_cleaner/values/constant.dart';
import 'package:staff_cleaner/values/font_custom.dart';
import 'package:staff_cleaner/values/output_utils.dart';
import 'package:staff_cleaner/values/screen_utils.dart';
import 'package:staff_cleaner/values/widget_utils.dart';
import 'package:uuid/uuid.dart';

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

  List<Map<dynamic, dynamic>> items = [];

  List<CustomerModel> customerList() {
    return context.watch<CustomerCubit>().state.data ?? [];
  }

  List<AddressModel> addressList() {
    String? id = customerNameController.dropDownValue?.value['id'];
    if (id != null) {
      return customerList()
              .firstWhere((element) => element.id == id)
              .addresses ??
          [];
    }
    return [];
  }

  List<StaffModel> staffList() {
    return context.watch<StaffCubit>().state.data ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.0.w,
        height: 1.0.h,
        color: primaryColor,
        child: Form(
          key: formKey,
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
                    onChanged: (value) {
                      setState(() {
                        customerAddressController.clearDropDown();
                      });
                    },
                    items: List.generate(customerList().length, (index) {
                      CustomerModel customer = customerList()[index];
                      return {
                        "name": customer.name,
                        "value": customer.toMap(),
                      };
                    }).toList(),
                    controller: customerNameController,
                    isRequired: true,
                  ),
                  V(16),
                  TextfieldDropdownComponent(
                    hintText: "Alamat",
                    onChanged: (value) {
                      setState(() {});
                    },
                    items: customerNameController.dropDownValue != null
                        ? List.generate(addressList().length, (index) {
                            AddressModel address = addressList()[index];
                            return {
                              "name": address.address,
                              "value": address.toMap(),
                            };
                          })
                        : [],
                    controller: customerAddressController,
                    isRequired: true,
                  ),
                  V(16),
                  TextfieldDateComponent(
                    hintText: "Tanggal layanan",
                    onChanged: (value) {},
                    color: Colors.white,
                    controller: serviceDateController,
                    isRequired: true,
                  ),
                  V(16),
                  TextfieldDateComponent(
                    hintText: "Jam layanan",
                    onChanged: (value) {},
                    color: Colors.white,
                    controller: serviceTimeController,
                    type: 'time',
                    isRequired: true,
                  ),
                  V(16),
                  const TextComponent(
                    "Item yang akan di bersihkan: ",
                    size: 18,
                    color: Colors.white,
                  ),
                  V(8),
                  Column(
                    children: items
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
                                                  items.removeAt(i);
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
                  V(8),
                  Center(
                    child: ButtonElevatedComponent(
                      "Tambah item",
                      onPressed: () {
                        return dialogList(
                            title: "Services",
                            item: listItemLayanan,
                            onGetItem: (service) {
                              logO("service", m: service);

                              String title = service["title"];
                              List<Map<String, dynamic>> itemYangDibersihkan =
                                  listItemDibershikan[title]!;

                              return dialogList(
                                  title: "Item",
                                  item: itemYangDibersihkan,
                                  onGetItem: (item) {
                                    setState(() {
                                      items.add({
                                        "service": title,
                                        "item": item["title"],
                                        "harga": item["harga"]
                                      });
                                    });

                                    logO("item", m: item);
                                  });
                            });
                      },
                    ),
                  ),
                  V(24),
                  ...List.generate(
                    staffsController.length,
                    (index) {
                      // filter staff
                      Set<StaffModel> allStaff = staffList().toSet();
                      Set<StaffModel> selectedStaff = staffsController
                          .where((element) => element.dropDownValue != null)
                          .map(
                              (e) => StaffModel.fromMap(e.dropDownValue!.value))
                          .toSet();
                      final List<StaffModel> staffs =
                          allStaff.difference(selectedStaff).toList();

                      return Container(
                        margin: EdgeInsets.only(top: index == 0 ? 0 : 16),
                        child: TextfieldDropdownComponent(
                          hintText: "Pilih Staf yang akan melayani",
                          onChanged: (value) {
                            setState(() {});
                          },
                          items: List.generate(staffs.length, (index) {
                            StaffModel staff = staffs[index];
                            return {
                              "name": staff.fullName,
                              "value": staff.toMap(),
                            };
                          }).toList(),
                          controller: staffsController[index],
                          isRequired: true,
                        ),
                      );
                    },
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
                            staffsController
                                .add(SingleValueDropDownController());
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
                      if (formKey.currentState?.validate() ?? false) {
                        if (items.isEmpty) {
                          showToast('Item yang dibersihkan belum dipilih');
                          return;
                        }
                        // add data schedule
                        ScheduleModel schedule = ScheduleModel(
                          id: const Uuid().v1(),
                          customer: CustomerModel.fromMap(
                            customerNameController.dropDownValue!.value,
                          ),
                          address: AddressModel.fromMap(
                            customerAddressController.dropDownValue!.value,
                          ),
                          serviceDate: serviceDateController.text,
                          serviceTime: serviceTimeController.text,
                          items: items,
                          staffs: staffsController
                              .map((e) =>
                                  StaffModel.fromMap(e.dropDownValue!.value))
                              .toList(),
                          isFinish: false,
                        );

                        context.read<ScheduleService>().update(
                              schedule: schedule,
                            );

                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
