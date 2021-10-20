part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  final TimerModel timerModel;
  const TimerStarted({required this.timerModel});
  @override
  String toString() {
    return 'TimerStarted { timerModel: $timerModel }';
  }
}

class TimerPaused extends TimerEvent {
  const TimerPaused();
}

class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class BreakSkipped extends TimerEvent {
  const BreakSkipped();
}

class TimerTicked extends TimerEvent {
  final TimerModel timerModel;
  const TimerTicked({required this.timerModel});

  @override
  List<Object> get props => [timerModel];
}

class UserScrolled extends TimerEvent {
  //final int duration;

  const UserScrolled();

  @override
  List<Object> get props => [];
}

class SelectedItemChanged extends TimerEvent {
  final int clockMinutes;

  const SelectedItemChanged({required this.clockMinutes});

  @override
  List<Object> get props => [clockMinutes];
}
