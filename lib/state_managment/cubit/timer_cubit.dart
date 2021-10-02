import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(TimerInitial());

  void setNewTime(int lastMinute, int lastSecond) {
    if (state is NewTime) {
      var lastState = (state as NewTime);
      int lastMinute = lastState.minutes;
      int lastSecond = lastState.seconds;

      if (lastSecond == 0) {
        emit(NewTime(
            minutes: lastMinute - 1,
            seconds: 59,
            isCountdownOver: lastState.isCountdownOver));
      } else {
        emit(NewTime(
            minutes: lastMinute,
            seconds: lastSecond - 1,
            isCountdownOver: lastState.isCountdownOver));
      }
    } else {
      if (lastSecond == 0) {
        emit(NewTime(
            minutes: lastMinute - 1, seconds: 59, isCountdownOver: false));
      } else {
        emit(NewTime(
            minutes: lastMinute,
            seconds: lastSecond - 1,
            isCountdownOver: false));
      }
    }
  }
}
