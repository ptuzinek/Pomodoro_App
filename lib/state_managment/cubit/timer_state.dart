part of 'timer_cubit.dart';

@immutable
abstract class TimerState extends Equatable {}

class TimerInitial extends TimerState {
  @override
  List<Object?> get props => [];
}

class CountdownStart extends TimerState {
  @override
  List<Object?> get props => [];
}

class NewTime extends TimerState {
  final int minutes;
  final int seconds;
  final bool isCountdownOver;

  NewTime({
    required this.minutes,
    required this.seconds,
    required this.isCountdownOver,
  });

  @override
  List<Object?> get props => [minutes, seconds];
}
