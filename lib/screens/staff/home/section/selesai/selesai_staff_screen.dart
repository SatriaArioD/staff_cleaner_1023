import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_cleaner/component/card/card_schedule.dart';
import 'package:staff_cleaner/cubit/base_state.dart';
import 'package:staff_cleaner/cubit/schedule_cubit.dart';
import 'package:staff_cleaner/models/schedule_model.dart';
import 'package:staff_cleaner/services/firebase_services.dart';

class SelesaiStaffScreen extends StatefulWidget {
  const SelesaiStaffScreen({super.key});

  @override
  State<SelesaiStaffScreen> createState() => _SelesaiStaffScreenState();
}

class _SelesaiStaffScreenState extends State<SelesaiStaffScreen> {
  final fs = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    final user = fs.getUser();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BlocBuilder<ScheduleCubit, BaseState<List<ScheduleModel>>>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ErrorState) {
                  return const Center(
                    child: Text('Terjadi Kesalahan!'),
                  );
                }
                if (state is LoadedState) {
                  final List<ScheduleModel> finishList = (state.data ?? [])
                      .where((element) =>
                          (element.isFinish ?? false) &&
                          element.staffs!
                              .any((element) => element.email == user?.email))
                      .toList();
                  if (finishList.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada data!'),
                    );
                  }
                  return CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: .85,
                      enlargeCenterPage: true,
                    ),
                    items: List.generate(
                      finishList.length,
                      (index) => CardSchedule(
                        schedule: finishList[index],
                        isAdmin: false,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
