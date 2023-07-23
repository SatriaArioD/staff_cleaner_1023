import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_cleaner/component/slider/component/body_corousel.dart';
import 'package:staff_cleaner/component/text/text_component.dart';
import 'package:staff_cleaner/models/schedule_model.dart';
import 'package:staff_cleaner/screens/admin/form/form_schedule_screen.dart';
import 'package:staff_cleaner/screens/general/schedule_detail_screen.dart';
import 'package:staff_cleaner/screens/staff/home/section/nota/nota_staff_screen.dart';
import 'package:staff_cleaner/services/firebase_services.dart';
import 'package:staff_cleaner/services/schedule_service.dart';
import 'package:staff_cleaner/values/color.dart';
import 'package:staff_cleaner/values/navigate_utils.dart';
import 'package:staff_cleaner/values/screen_utils.dart';

class CardSchedule extends StatelessWidget {
  final ScheduleModel schedule;
  final bool isAdmin;

  CardSchedule({
    Key? key,
    required this.schedule,
    required this.isAdmin,
  }) : super(key: key);

  final fs = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: SizedBox(
          width: 0.8.w,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: schedule.isFinish ?? false
                      ? Icon(
                          Icons.check_circle_outline,
                          color: primaryColor,
                        )
                      : isAdmin
                          ? InkWell(
                              onTap: () {
                                navigatePush(
                                  ScheduleDetailScreen(
                                    schedule: schedule,
                                    isAdmin: isAdmin,
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextComponent(
                                    'Detail',
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    Icons.arrow_right_outlined,
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                            )
                          : Checkbox(
                              value: false,
                              onChanged: (bool? value) async {
                                ScheduleService scheduleService =
                                    context.read<ScheduleService>();

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: const Text(
                                        'Apakah pekerjaan telah selesai',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            // dismiss dialog
                                            Navigator.pop(context);

                                            await scheduleService.update(
                                              schedule: schedule.copyWith(
                                                isFinish: true,
                                              ),
                                            );
                                          },
                                          child: const Text('Ya'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // dismiss dialog
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Tidak'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyCorousel(
                      'Nama customer',
                      schedule.customer?.name ?? '-',
                    ),
                    if (isAdmin) ...[
                      BodyCorousel(
                        'Nama Staff Yang bertugas',
                        schedule.staffs
                                ?.map((e) => e.fullName ?? '')
                                .toList()
                                .join(', ') ??
                            '',
                      ),
                    ],
                    if (!isAdmin) ...[
                      BodyCorousel(
                        'No Hp',
                        schedule.customer?.phoneNumber ?? '-',
                      ),
                    ],
                    BodyCorousel(
                      'Alamat',
                      schedule.address?.address ?? '',
                    ),
                    if (!isAdmin) ...[
                      BodyCorousel(
                        'Tanggal layanan',
                        schedule.serviceDate ?? '-',
                      ),
                      BodyCorousel(
                        'Jam layanan',
                        schedule.serviceTime ?? '-',
                      ),
                      BodyCorousel(
                        'Daya',
                        schedule.address?.electricalPower ?? '-',
                      ),
                    ],
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (schedule.isFinish ?? false) ...[
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              final user = fs.getUser();

                              navigatePush(
                                NotaStaffScreen(
                                  noSurat: '',
                                  schedule: schedule,
                                  user: user,
                                ),
                              );
                            },
                            icon: const Icon(Icons.speaker_notes),
                          ),
                        ),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextComponent(
                            "${schedule.serviceDate} ${schedule.serviceTime}",
                            size: 16,
                          ),
                          TextButton(
                            onPressed: () {
                              if (isAdmin && !(schedule.isFinish ?? true)) {
                                // go to detail
                                navigatePush(
                                  FormScheduleScreen(schedule: schedule),
                                );
                              } else {
                                // go to detail
                                navigatePush(
                                  ScheduleDetailScreen(
                                    schedule: schedule,
                                    isAdmin: isAdmin,
                                  ),
                                );
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextComponent(
                                  (isAdmin && !(schedule.isFinish ?? true))
                                      ? 'Edit'
                                      : 'Detail',
                                  size: 16,
                                  color: primaryColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_right_outlined,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
