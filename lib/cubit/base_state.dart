import 'package:equatable/equatable.dart';

/// abstract class base state
abstract class BaseState<T> extends Equatable {
  final T? data;

  const BaseState({this.data});

  @override
  List<Object?> get props => [
        data,
      ];
}

/// initialized state
class InitializedState<T> extends BaseState<T> {
  const InitializedState() : super();
}

/// loading state
class LoadingState<T> extends BaseState<T> {
  const LoadingState() : super();
}

/// loaded state
class LoadedState<T> extends BaseState<T> {
  const LoadedState({
    T? data,
  }) : super(data: data);
}

/// error state
class ErrorState<T> extends BaseState<T> {
  final String? message;

  const ErrorState({T? data, this.message}) : super(data: data);

  @override
  List<Object?> get props => [data, message];
}
