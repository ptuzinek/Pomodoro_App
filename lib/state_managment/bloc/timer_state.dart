part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final TimerModel timerModel;

  const TimerState({required this.timerModel});

  @override
  List<Object> get props => [timerModel];
}

class TimerInitial extends TimerState {
  final TimerModel timerModel;

  const TimerInitial({required this.timerModel})
      : super(timerModel: timerModel);

  @override
  String toString() => 'TimerInitial { timerModel: $timerModel }';
}

class TimerRunPause extends TimerState {
  final TimerModel timerModel;

  const TimerRunPause({required this.timerModel})
      : super(timerModel: timerModel);

  @override
  String toString() => 'TimerRunPause { timerModel: $timerModel }';
}

class TimerRunInProgress extends TimerState {
  final TimerModel timerModel;

  const TimerRunInProgress({required this.timerModel})
      : super(timerModel: timerModel);

  @override
  String toString() => 'TimerRunInProgress { timerModel: $timerModel }';
}

class TimerRunComplete extends TimerState {
  final TimerModel timerModel;

  TimerRunComplete({required this.timerModel})
      : super(timerModel: TimerModel());

  @override
  List<Object> get props => [timerModel];

  @override
  String toString() => 'TimerRunComplete { timerModel: $timerModel }';
}

class TimerRunStart extends TimerState {
  final TimerModel timerModel;

  TimerRunStart({required this.timerModel}) : super(timerModel: TimerModel());

  @override
  List<Object> get props => [timerModel];

  @override
  String toString() => 'TimerRunStart { timerModel: $timerModel }';
}
