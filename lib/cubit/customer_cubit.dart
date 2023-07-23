import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staff_cleaner/cubit/base_state.dart';
import 'package:staff_cleaner/models/customer_model.dart';
import 'package:staff_cleaner/services/customer_service.dart';

class CustomerCubit extends Cubit<BaseState<List<CustomerModel>>> {
  final CustomerService customerService;

  CustomerCubit({
    required this.customerService,
  }) : super(const InitializedState());

  StreamSubscription<List<CustomerModel>>? streamSubscription;

  void init() async {
    emit(const LoadingState());

    streamSubscription = customerService.watch().listen(
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
