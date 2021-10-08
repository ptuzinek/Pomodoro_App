import 'dart:async';

import 'package:flutter/material.dart';

class ClockStateModel {
  final int minutes;
  final int seconds;
  final int listViewItemPosition;
  final int focusSessionsCompleted;
  final ScrollPhysics physics;
  final Timer? timer;
  final bool isPaused;
  final bool isFocus;
  final bool isLongBreak;
  final bool isListIndexChange;
  final Color backgroundColor;

  ClockStateModel({
    this.minutes = 25,
    this.seconds = 0,
    this.listViewItemPosition = 24,
    this.focusSessionsCompleted = 0,
    this.physics = const FixedExtentScrollPhysics(),
    this.timer,
    this.isPaused = true,
    this.isFocus = true,
    this.isLongBreak = false,
    this.isListIndexChange = true,
    this.backgroundColor = Colors.white,
  });

  ClockStateModel copyWith({
    int? minutes,
    int? seconds,
    int? listViewItemPosition,
    int? focusSessionsCompleted,
    ScrollPhysics? physics,
    Timer? timer,
    bool? isPaused,
    bool? isFocus,
    bool? isLongBreak,
    bool? isListIndexChange,
    Color? backgroundColor,
  }) {
    return ClockStateModel(
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
      listViewItemPosition: listViewItemPosition ?? this.listViewItemPosition,
      focusSessionsCompleted:
          focusSessionsCompleted ?? this.focusSessionsCompleted,
      physics: physics ?? this.physics,
      timer: timer ?? this.timer,
      isPaused: isPaused ?? this.isPaused,
      isFocus: isFocus ?? this.isFocus,
      isLongBreak: isLongBreak ?? this.isLongBreak,
      isListIndexChange: isListIndexChange ?? this.isListIndexChange,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
