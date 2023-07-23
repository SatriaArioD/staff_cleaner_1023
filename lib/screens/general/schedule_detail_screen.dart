import 'package:flutter/material.dart';
import 'package:staff_cleaner/models/schedule_model.dart';
import 'package:staff_cleaner/screens/staff/home/section/detail/section/map/map_screen.dart';
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

  const ScheduleDetailScreen({super.key, required this.schedule});

  @override
  State<ScheduleDetailScreen> createState() => _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends State<ScheduleDetailScreen> {
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
                              "1. [${e["service"]}] ${e["item"]}",
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
              )
            ]),
          ),
        ),
      ),
    );
  }
}
