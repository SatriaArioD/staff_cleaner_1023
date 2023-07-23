import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_cleaner/component/card/card_schedule.dart';
import 'package:staff_cleaner/cubit/base_state.dart';
import 'package:staff_cleaner/cubit/schedule_cubit.dart';
import 'package:staff_cleaner/models/schedule_model.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                final List<ScheduleModel> scheduledList = (state.data ?? [])
                    .where((element) => !(element.isFinish ?? true))
                    .toList();
                if (scheduledList.isEmpty) {
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
                    scheduledList.length,
                    (index) => CardSchedule(
                      schedule: scheduledList[index],
                      isAdmin: true,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
