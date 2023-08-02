import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_cleaner/models/schedule_model.dart';
import 'package:staff_cleaner/screens/staff/home/section/detail/section/map/map_screen.dart';
import 'package:staff_cleaner/services/schedule_service.dart';
import 'package:staff_cleaner/values/constant.dart';
import 'package:staff_cleaner/values/screen_utils.dart';

import '../../../../../component/button/button_component.dart';
import '../../../../../component/button/link_component.dart';
import '../../../../../component/text/card_text_component.dart';
import '../../../../../component/text/text_component.dart';
import '../../../../../values/color.dart';
import '../../../../../values/font_custom.dart';
import '../../../../../values/navigate_utils.dart';
import '../../../../../values/output_utils.dart';
import '../../../../../values/widget_utils.dart';

class ScheduleDetailScreen extends StatefulWidget {
  final ScheduleModel schedule;
  final bool isAdmin;

  const ScheduleDetailScreen({
    super.key,
    required this.schedule,
    required this.isAdmin,
  });

  @override
  State<ScheduleDetailScreen> createState() => _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends State<ScheduleDetailScreen> {
  List<Map<dynamic, dynamic>> items = [];

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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const TextComponent(
                "Detail",
                color: Colors.white,
              ),
              V(32),
              CardTextComponent(
                "Nama customer",
                widget.schedule.customer?.name ?? '-',
              ),
              V(16),
              CardTextComponent(
                "Tanggal lahir",
                widget.schedule.customer?.birthdate ?? '-',
              ),
              V(16),
              CardTextComponent(
                "No. handphone",
                widget.schedule.customer?.phoneNumber ?? '-',
              ),
              V(16),
              CardTextComponent(
                "Staff Yang Melayani",
                widget.schedule.staffs
                        ?.map((e) => e.fullName ?? '')
                        .toList()
                        .join(', ') ??
                    '-',
              ),
              V(16),
              CardTextComponent(
                "Tanggal layanan",
                widget.schedule.serviceDate ?? '-',
              ),
              V(16),
              CardTextComponent(
                "Jam layanan",
                widget.schedule.serviceTime ?? '-',
              ),
              V(16),
              const TextComponent(
                "Item yang akan di bersihkan: ",
                size: 18,
                color: Colors.white,
              ),
              V(8),
              ...List.generate(
                widget.schedule.items?.length ?? 0,
                (index) {
                  var e = widget.schedule.items![index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        elevation: 8,
                        clipBehavior: Clip.hardEdge,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 1.0.w,
                            child: TextComponent(
                              "${index + 1}. [${e["service"]}] ${e["item"]}",
                              size: 16,
                              weight: Lato.Light,
                            ),
                          ),
                        ),
                      ),
                      V(8)
                    ],
                  );
                },
              ),
              if (!widget.isAdmin) ...[
                V(8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    items.length,
                    (index) => Container(
                      margin: EdgeInsets.only(top: index == 0 ? 0 : 8),
                      child: Card(
                        elevation: 8,
                        clipBehavior: Clip.hardEdge,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextComponent(
                                "${index + 1}. [${items[index]["service"]}] ${items[index]["item"]}",
                                size: 10,
                                weight: Lato.Light,
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    items.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.remove),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                V(8),
                Center(
                  child: ButtonElevatedComponent(
                    "Tambah item Lain",
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
              ],
              V(24),
              CardTextComponent(
                "Daya listrik",
                "${widget.schedule.address?.electricalPower ?? '-'} watt",
              ),
              V(16),
              CardTextComponent(
                "Mengetahui yukbersihin dari ?",
                widget.schedule.customer?.knowFrom ?? '-',
              ),
              V(16),
              CardTextComponent(
                "Alamat lengkap",
                widget.schedule.address?.address ?? '-',
              ),
              V(32),
              Center(
                child: LinkComponent(
                  "Lihat Lokasi >",
                  onTap: () {
                    logO(
                      "widget.item",
                      m: widget.schedule.address?.toMap(),
                    );
                    navigatePush(
                      MapScreen(
                        lokasi: {
                          'latitude': '${widget.schedule.address?.latitude}',
                          'longitude': '${widget.schedule.address?.longitude}',
                        },
                      ),
                    );
                  },
                ),
              ),
              V(32),
              Center(
                child: ButtonElevatedComponent(
                  "kembali",
                  onPressed: () {
                    navigatePop();
                  },
                ),
              ),
              if (items.isNotEmpty) ...[
                V(16),
                Center(
                  child: ButtonElevatedComponent(
                    "Update Data",
                    onPressed: () {
                      context.read<ScheduleService>().update(
                            schedule: widget.schedule.copyWith(
                              items: [
                                ...widget.schedule.items!,
                                ...items,
                              ],
                            ),
                          );

                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}
