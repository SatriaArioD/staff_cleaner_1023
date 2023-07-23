import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:staff_cleaner/component/button/button_component.dart';
import 'package:staff_cleaner/component/text/text_component.dart';
import 'package:staff_cleaner/component/textfield/textfield_component.dart';
import 'package:staff_cleaner/component/textfield/textfield_date_component.dart';
import 'package:staff_cleaner/models/address_model.dart';
import 'package:staff_cleaner/models/customer_model.dart';
import 'package:staff_cleaner/screens/admin/form/select_location_screen.dart';
import 'package:staff_cleaner/services/customer_service.dart';
import 'package:staff_cleaner/values/color.dart';
import 'package:staff_cleaner/values/constant.dart';
import 'package:staff_cleaner/values/output_utils.dart';
import 'package:staff_cleaner/values/screen_utils.dart';
import 'package:staff_cleaner/values/widget_utils.dart';
import 'package:uuid/uuid.dart';

class FormCustomerScreen extends StatefulWidget {
  const FormCustomerScreen({Key? key}) : super(key: key);

  @override
  State<FormCustomerScreen> createState() => _FormCustomerScreenState();
}

class _FormCustomerScreenState extends State<FormCustomerScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController knowFromController = TextEditingController();
  final List<TextEditingController> addressesController = [
    TextEditingController()
  ];
  final List<TextEditingController> electricalPowersController = [
    TextEditingController()
  ];

  List<latlong2.LatLng?> latLngs = [null];

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
                    "Input Customer",
                    color: Colors.white,
                  ),
                  V(32),
                  TextfieldComponent(
                    hintText: "Nama customer...",
                    onChanged: (value) {},
                    color: Colors.white,
                    controller: nameController,
                    isRequired: true,
                  ),
                  V(16),
                  TextfieldDateComponent(
                    hintText: "Tanggal Lahir",
                    onChanged: (value) {},
                    color: Colors.white,
                    controller: birthdateController,
                    isRequired: true,
                  ),
                  V(16),
                  TextfieldComponent(
                    hintText: "No. Handphone...",
                    onChanged: (value) {},
                    color: Colors.white,
                    inputType: TextInputType.phone,
                    controller: phoneNumberController,
                    isRequired: true,
                  ),
                  V(16),
                  TextfieldComponent(
                    hintText: "Mengetahui Tukbersihin Dari...",
                    onChanged: (value) {},
                    color: Colors.white,
                    controller: knowFromController,
                    isRequired: true,
                  ),
                  V(16),
                  ...List.generate(
                    addressesController.length,
                    (index) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextComponent(
                                "Alamat ${index + 1}",
                                color: Colors.white,
                              ),
                            ),
                            if (index != 0) ...[
                              H(8),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    addressesController.removeAt(index);
                                    electricalPowersController.removeAt(index);
                                    latLngs.removeAt(index);
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                        V(8),
                        TextfieldComponent(
                          hintText: "Alamat lengkap...",
                          onChanged: (value) {},
                          color: Colors.white,
                          controller: addressesController[index],
                          isRequired: true,
                        ),
                        V(16),
                        const TextComponent(
                          "Lokasi",
                          color: Colors.white,
                        ),
                        V(8),
                        InkWell(
                          onTap: () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SelectLocationScreen(),
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                latLngs[index] = result;
                              });
                            }
                          },
                          child: latLngs[index] == null
                              ? const Center(
                                  child: TextComponent(
                                    "Pilih Lokasi",
                                    color: Colors.white,
                                    size: 18,
                                    weight: FontWeight.w500,
                                  ),
                                )
                              : AspectRatio(
                                  aspectRatio: 21 / 9,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: FlutterMap(
                                        options: MapOptions(
                                          center: latLngs[index],
                                          zoom: 16,
                                        ),
                                        nonRotatedChildren: [
                                          TileLayer(
                                            urlTemplate:
                                                "https://api.tomtom.com/map/1/tile/basic/main/"
                                                "{z}/{x}/{y}.png?key=$apiKey",
                                            additionalOptions: const {
                                              "apiKey": apiKey,
                                            },
                                          ),
                                          MarkerLayer(
                                            markers: [
                                              Marker(
                                                point: latLngs[index]!,
                                                width: 35,
                                                height: 35,
                                                builder: (context) =>
                                                    const Icon(
                                                  Icons.location_pin,
                                                  color: Colors.red,
                                                  size: 24,
                                                ),
                                                anchorPos: AnchorPos.align(
                                                    AnchorAlign.top),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        V(16),
                        TextfieldComponent(
                          hintText: "Daya Listrik",
                          onChanged: (value) {},
                          color: Colors.white,
                          inputType: TextInputType.number,
                          controller: electricalPowersController[index],
                          isRequired: true,
                        ),
                        V(16),
                      ],
                    ),
                  ),
                  V(16),
                  ButtonElevatedComponent(
                    "Tambah Alamat",
                    onPressed: () {
                      setState(() {
                        addressesController.add(TextEditingController());
                        electricalPowersController.add(TextEditingController());
                        latLngs.add(null);
                      });
                    },
                  ),
                  V(48),
                  Center(
                    child: ButtonElevatedComponent(
                      "Simpan",
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          if (latLngs.any((element) => element == null)) {
                            print('masuk sini kah ????');
                            showToast('Silakan dilengkapi semua lokasi');
                            return;
                          }
                          // add data customer
                          CustomerModel customer = CustomerModel(
                            id: const Uuid().v1(),
                            name: nameController.text,
                            birthdate: birthdateController.text,
                            phoneNumber: phoneNumberController.text,
                            knowFrom: knowFromController.text,
                            addresses: List.generate(
                              addressesController.length,
                              (index) => AddressModel(
                                address: addressesController[index].text,
                                latitude: latLngs[index]!.latitude,
                                longitude: latLngs[index]!.longitude,
                                electricalPower:
                                    electricalPowersController[index].text,
                              ),
                            ),
                          );

                          context.read<CustomerService>().update(
                                customer: customer,
                              );

                          Navigator.pop(context);
                        }
                      },
                    ),
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
