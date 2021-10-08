class TimerModel {
  final int duration;
  final bool isFocus;
  final int completedSessions;
  final int clockMinutes;
  bool isUserScroll;

  TimerModel({
    this.duration = 25 * 60,
    this.isFocus = true,
    this.completedSessions = 0,
    this.clockMinutes = 25,
    this.isUserScroll = false,
  });

  TimerModel copyWith({
    int? duration,
    bool? isFocus,
    int? completedSessions,
    int? clockMinutes,
    bool? isUserScroll,
  }) {
    return TimerModel(
      duration: duration ?? this.duration,
      isFocus: isFocus ?? this.isFocus,
      completedSessions: completedSessions ?? this.completedSessions,
      clockMinutes: clockMinutes ?? this.clockMinutes,
      isUserScroll: isUserScroll ?? this.isUserScroll,
    );
  }

  @override
  String toString() {
    return 'TimerModel(duration: $duration, isFocus: $isFocus, completedSessions: $completedSessions, clockMinutes: $clockMinutes, isUserScroll: $isUserScroll)';
  }
}
