import 'package:flutter/material.dart';

class TimerModel {
  final int duration;
  final bool isFocus;
  final int completedSessions;
  final int clockMinutes;
  final bool isUserScroll;
  final ScrollPhysics physics;

  TimerModel({
    this.duration = 25 * 60,
    this.isFocus = true,
    this.completedSessions = 0,
    this.clockMinutes = 25,
    this.isUserScroll = false,
    this.physics = const AlwaysScrollableScrollPhysics(),
  });

  TimerModel copyWith({
    int? duration,
    bool? isFocus,
    int? completedSessions,
    int? clockMinutes,
    bool? isUserScroll,
    ScrollPhysics? physics,
  }) {
    return TimerModel(
      duration: duration ?? this.duration,
      isFocus: isFocus ?? this.isFocus,
      completedSessions: completedSessions ?? this.completedSessions,
      clockMinutes: clockMinutes ?? this.clockMinutes,
      isUserScroll: isUserScroll ?? this.isUserScroll,
      physics: physics ?? this.physics,
    );
  }

  @override
  String toString() {
    return 'TimerModel(duration: $duration, isFocus: $isFocus, completedSessions: $completedSessions, clockMinutes: $clockMinutes, isUserScroll: $isUserScroll, physics: $physics)';
  }
}
