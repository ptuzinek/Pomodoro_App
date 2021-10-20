import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/data/ticker.dart';
import 'package:pomodoro_app/data/timer_model.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker ticker;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required this.ticker})
      : super(TimerInitial(timerModel: TimerModel())) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<SelectedItemChanged>(_onSelected);
    on<UserScrolled>(_onScroll);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
    on<BreakSkipped>(_onSkipped);
  }
  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    if (event.timerModel.duration > 0) {
      emit(TimerRunStart(
          timerModel: event.timerModel.copyWith(
        isUserScroll: false,
        isPaused: false,
      )));
      _tickerSubscription =
          ticker.tick(ticks: event.timerModel.duration).listen((duration) {
        add(TimerTicked(
            timerModel: state.timerModel.copyWith(
          duration: duration,
          isUserScroll: false,
          isPaused: false,
        )));
      });
    } else {
      add(TimerTicked(
          timerModel: state.timerModel.copyWith(
        duration: 0,
        isUserScroll: false,
      )));
    }
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(
          timerModel: state.timerModel.copyWith(
        physics: AlwaysScrollableScrollPhysics(),
        isPaused: true,
      )));
    }
  }

  void _onResumed(TimerResumed resume, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(
          timerModel: state.timerModel.copyWith(
        isUserScroll: false,
        isPaused: false,
      )));
    }
  }

  void _onSelected(SelectedItemChanged event, Emitter<TimerState> emit) {
    if (state.timerModel.isUserScroll) {
      emit(TimerInitial(
          timerModel: state.timerModel.copyWith(
        duration: event.clockMinutes * 60,
        clockMinutes: event.clockMinutes,
      )));
    }
  }

  void _onScroll(UserScrolled event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitial(
      timerModel: state.timerModel.copyWith(
        isUserScroll: true,
        physics: FixedExtentScrollPhysics(),
        isPaused: true,
      ),
    ));
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitial(timerModel: TimerModel()));
  }

  void _onSkipped(BreakSkipped event, Emitter<TimerState> emit) {
    print('Cancel!');
    _tickerSubscription?.cancel();
    emit(TimerRunComplete(
        timerModel: state.timerModel.copyWith(
      duration: 25 * 60,
    )));

    add(TimerStarted(
        timerModel: state.timerModel.copyWith(
      duration: 25 * 60,
      isFocus: !state.timerModel.isFocus,
      clockMinutes: 25,
      isUserScroll: false,
    )));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    if (event.timerModel.duration > 0) {
      emit(TimerRunInProgress(
          timerModel: event.timerModel.copyWith(isUserScroll: false)));
    } else {
      _tickerSubscription?.cancel();
      if (state.timerModel.isFocus &&
          (state.timerModel.completedSessions == 0 ||
              (state.timerModel.completedSessions + 1) % 4 != 0)) {
        emit(TimerRunComplete(
            timerModel: event.timerModel.copyWith(
          duration: 5 * 60,
        )));
        add(TimerStarted(
            timerModel: event.timerModel.copyWith(
                duration: 5 * 60,
                isFocus: !event.timerModel.isFocus,
                completedSessions: event.timerModel.completedSessions + 1,
                clockMinutes: 5,
                isUserScroll: false)));
      } else if (state.timerModel.isFocus &&
          (state.timerModel.completedSessions + 1) % 4 == 0) {
        emit(TimerRunComplete(
            timerModel: event.timerModel.copyWith(
          duration: 25 * 60,
        )));

        add(TimerStarted(
            timerModel: event.timerModel.copyWith(
                duration: 25 * 60,
                isFocus: !event.timerModel.isFocus,
                completedSessions: event.timerModel.completedSessions + 1,
                clockMinutes: 25,
                isUserScroll: false)));
      } else {
        emit(TimerRunComplete(
            timerModel: event.timerModel.copyWith(
          duration: 25 * 60,
        )));

        add(TimerStarted(
            timerModel: event.timerModel.copyWith(
                duration: 25 * 60,
                isFocus: !event.timerModel.isFocus,
                completedSessions: event.timerModel.completedSessions,
                clockMinutes: 25,
                isUserScroll: false)));
      }
    }
  }

  @override
  void onTransition(Transition<TimerEvent, TimerState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
