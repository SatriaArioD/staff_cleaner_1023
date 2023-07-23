import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_cleaner/cubit/base_state.dart';
import 'package:staff_cleaner/models/schedule_model.dart';
import 'package:staff_cleaner/services/schedule_service.dart';

class ScheduleCubit extends Cubit<BaseState<List<ScheduleModel>>> {
  final ScheduleService scheduleService;

  ScheduleCubit({
    required this.scheduleService,
  }) : super(const InitializedState());

  StreamSubscription<List<ScheduleModel>>? streamSubscription;

  void init() async {
    emit(const LoadingState());

    streamSubscription = scheduleService.watch().listen(
      (data) {
        emit(LoadedState(data: data));
      },
    );
  }

  @override
  Future<void> close() {
    streamSubscription?.cancel();
    return super.close();
  }
}
