import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_cleaner/component/button/button_component.dart';
import 'package:staff_cleaner/component/text/text_component.dart';
import 'package:staff_cleaner/component/textfield/textfield_component.dart';
import 'package:staff_cleaner/component/textfield/textfield_date_component.dart';
import 'package:staff_cleaner/component/textfield/textfield_dropdown_component%20.dart';
import 'package:staff_cleaner/cubit/customer_cubit.dart';
import 'package:staff_cleaner/cubit/staff_cubit.dart';
import 'package:staff_cleaner/dialog/custom_price_dialog.dart';
import 'package:staff_cleaner/models/address_model.dart';
import 'package:staff_cleaner/models/customer_model.dart';
import 'package:staff_cleaner/models/schedule_model.dart';
import 'package:staff_cleaner/models/staff_model.dart';
import 'package:staff_cleaner/screens/admin/form/form_customer_screen.dart';
import 'package:staff_cleaner/services/schedule_service.dart';
import 'package:staff_cleaner/values/color.dart';
import 'package:staff_cleaner/values/constant.dart';
import 'package:staff_cleaner/values/font_custom.dart';
import 'package:staff_cleaner/values/output_utils.dart';
import 'package:staff_cleaner/values/screen_utils.dart';
import 'package:staff_cleaner/values/widget_utils.dart';
import 'package:uuid/uuid.dart';

class FormScheduleScreen extends StatefulWidget {
  final ScheduleModel? schedule;

  const FormScheduleScreen({
    Key? key,
    this.schedule,
  }) : super(key: key);

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
  final List<SingleValueDropDownController> staffsController = [
    SingleValueDropDownController()
  ];

  List<Map<dynamic, dynamic>> items = [];

  final List<String> discountType = ['Persentase', 'Nominal'];
  String? discountSelected;
  final SingleValueDropDownController discountController =
      SingleValueDropDownController();
  final TextEditingController discountTextController = TextEditingController();

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
  void initState() {
    if (widget.schedule != null) {
      customerNameController.setDropDown(
        DropDownValueModel(
          name: widget.schedule!.customer?.name ?? '',
          value: widget.schedule!.customer?.toMap(),
        ),
      );
      customerAddressController.setDropDown(
        DropDownValueModel(
          name: widget.schedule!.address?.address ?? '',
          value: widget.schedule!.address?.toMap(),
        ),
      );
      serviceDateController.text = widget.schedule!.serviceDate ?? '';
      serviceTimeController.text = widget.schedule!.serviceTime ?? '';

      items = widget.schedule!.items ?? [];

      staffsController.clear();
      for (StaffModel staff in widget.schedule!.staffs ?? []) {
        staffsController.add(
          SingleValueDropDownController()
            ..setDropDown(
              DropDownValueModel(
                name: staff.fullName ?? '',
                value: staff.toMap(),
              ),
            ),
        );
      }

      String? discountType = widget.schedule!.discountType;
      if (discountType != null) {
        discountController.setDropDown(
          DropDownValueModel(name: discountType, value: discountType),
        );
        discountTextController.text = widget.schedule!.discount ?? '';
      }
    }
    super.initState();
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
                    readOnly: widget.schedule != null,
                  ),
                  V(16),
                  if (customerNameController.dropDownValue != null) ...[
                    ButtonElevatedComponent(
                      "Edit Customer",
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormCustomerScreen(
                              customer: CustomerModel.fromMap(
                                customerNameController.dropDownValue!.value,
                              ),
                            ),
                          ),
                        );

                        setState(() {});
                      },
                    ),
                  ],
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
                    readOnly: widget.schedule != null,
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
                            onGetItem: (service) async {
                              logO("service", m: service);

                              String title = service["title"];

                              if (title == 'Disinfeksi') {
                                /// dialog add panjang, lebar, harga
                                Map? result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomPriceDialog(
                                      title: title,
                                    );
                                  },
                                );

                                if (result != null) {
                                  setState(() {
                                    Map value = {
                                      "service": title,
                                      "item": title,
                                    };
                                    value.addAll(result);
                                    items.add(value);
                                  });
                                }
                                return {};
                              }

                              List<Map<String, dynamic>> itemYangDibersihkan =
                                  listItemDibershikan[title]!;

                              return dialogList(
                                  title: "Item",
                                  item: itemYangDibersihkan,
                                  onGetItem: (item) async {
                                    bool isCustom = item['is_custom'] ?? false;

                                    if (isCustom) {
                                      /// dialog add panjang, lebar, harga
                                      Map? result = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomPriceDialog(
                                              title: item["title"]);
                                        },
                                      );

                                      if (result != null) {
                                        setState(() {
                                          Map value = {
                                            "service": title,
                                            "item": item["title"],
                                          };
                                          value.addAll(result);
                                          items.add(value);
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        items.add({
                                          "service": title,
                                          "item": item["title"],
                                          "harga": item["harga"]
                                        });
                                      });
                                    }

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
                  V(24),
                  TextfieldDropdownComponent(
                    hintText: "Tambahkan Diskon",
                    items: List.generate(discountType.length, (index) {
                      return {
                        "name": discountType[index],
                        "value": discountType[index],
                      };
                    }).toList(),
                    controller: discountController,
                    onChanged: (val) {
                      discountTextController.clear();
                      setState(() {});
                    },
                  ),
                  if (discountController.dropDownValue != null) ...[
                    V(16),
                    TextfieldComponent(
                      hintText:
                          "${discountController.dropDownValue!.name} Diskon",
                      controller: discountTextController,
                      inputType: TextInputType.number,
                      color: Colors.white,
                    ),
                  ],
                  V(48),
                  Center(
                    child: ButtonElevatedComponent(
                      "Simpan",
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          if (items.isEmpty) {
                            showToast('Item yang dibersihkan belum dipilih');
                            return;
                          }
                          // add data schedule
                          ScheduleModel schedule = ScheduleModel(
                            id: widget.schedule?.id ?? const Uuid().v1(),
                            customer: widget.schedule?.customer ??
                                CustomerModel.fromMap(
                                  customerNameController.dropDownValue!.value,
                                ),
                            address: widget.schedule?.address ??
                                AddressModel.fromMap(
                                  customerAddressController
                                      .dropDownValue!.value,
                                ),
                            serviceDate: serviceDateController.text,
                            serviceTime: serviceTimeController.text,
                            items: items,
                            staffs: staffsController
                                .map((e) =>
                                    StaffModel.fromMap(e.dropDownValue!.value))
                                .toList(),
                            isFinish: false,
                            discountType:
                                discountController.dropDownValue?.name,
                            discount: discountTextController.text,
                          );

                          context.read<ScheduleService>().update(
                                schedule: schedule,
                              );

                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  if (widget.schedule != null) ...[
                    V(16),
                    Center(
                      child: ButtonElevatedComponent(
                        "Hapus Jadwal",
                        onPressed: () {
                          context
                              .read<ScheduleService>()
                              .delete(id: widget.schedule!.id!);

                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
