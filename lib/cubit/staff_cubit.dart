import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_cleaner/cubit/base_state.dart';
import 'package:staff_cleaner/models/staff_model.dart';
import 'package:staff_cleaner/services/staff_service.dart';

class StaffCubit extends Cubit<BaseState<List<StaffModel>>> {
  final StaffService staffService;

  StaffCubit({
    required this.staffService,
  }) : super(const InitializedState());

  StreamSubscription<List<StaffModel>>? streamSubscription;

  void init() async {
    emit(const LoadingState());

    streamSubscription = staffService.watch().listen(
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
