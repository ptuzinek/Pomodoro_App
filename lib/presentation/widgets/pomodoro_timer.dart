import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_app/state_managment/bloc/timer_bloc.dart';

const ClockHandsList = [
  const ClockHands(index: 0),
  const ClockHands(index: 1),
  const ClockHands(index: 2),
  const ClockHands(index: 3),
  const ClockHands(index: 4),
  const ClockHands(index: 5),
  const ClockHands(index: 6),
  const ClockHands(index: 7),
  const ClockHands(index: 8),
  const ClockHands(index: 9),
  const ClockHands(index: 10),
  const ClockHands(index: 11),
  const ClockHands(index: 12),
  const ClockHands(index: 13),
  const ClockHands(index: 14),
  const ClockHands(index: 15),
  const ClockHands(index: 16),
  const ClockHands(index: 17),
  const ClockHands(index: 18),
  const ClockHands(index: 19),
  const ClockHands(index: 20),
  const ClockHands(index: 21),
  const ClockHands(index: 22),
  const ClockHands(index: 23),
  const ClockHands(index: 24),
  const ClockHands(index: 25),
  const ClockHands(index: 26),
  const ClockHands(index: 27),
  const ClockHands(index: 28),
  const ClockHands(index: 29),
  const ClockHands(index: 30),
  const ClockHands(index: 31),
  const ClockHands(index: 32),
  const ClockHands(index: 33),
  const ClockHands(index: 34),
  const ClockHands(index: 35),
  const ClockHands(index: 36),
  const ClockHands(index: 37),
  const ClockHands(index: 38),
  const ClockHands(index: 39),
  const ClockHands(index: 40),
  const ClockHands(index: 41),
  const ClockHands(index: 42),
  const ClockHands(index: 43),
  const ClockHands(index: 44),
  const ClockHands(index: 45),
  const ClockHands(index: 46),
  const ClockHands(index: 47),
  const ClockHands(index: 48),
  const ClockHands(index: 49),
  const ClockHands(index: 50),
  const ClockHands(index: 51),
  const ClockHands(index: 52),
  const ClockHands(index: 53),
  const ClockHands(index: 54),
  const ClockHands(index: 55),
  const ClockHands(index: 56),
  const ClockHands(index: 57),
  const ClockHands(index: 58),
  const ClockHands(index: 59),
];

class PomodoroTimer extends StatelessWidget {
  const PomodoroTimer({
    Key? key,
    required this.onSelectedItemChanged,
    required this.controller,
    required this.onUserScroll,
  }) : super(key: key);
  final Function(int min) onSelectedItemChanged;
  final FixedExtentScrollController controller;
  final bool Function(UserScrollNotification) onUserScroll;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: NotificationListener<UserScrollNotification>(
        onNotification: onUserScroll,
        child: BlocBuilder<TimerBloc, TimerState>(
          buildWhen: (previous, current) {
            if (previous.timerModel.physics.toString() !=
                current.timerModel.physics.toString()) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            print('BUILDING POMODORO TIMER');
            return ListWheelScrollView.useDelegate(
              controller: controller,
              itemExtent: 40,
              squeeze: 2,
              diameterRatio: 1.3,
              physics: state.timerModel.physics,
              onSelectedItemChanged: onSelectedItemChanged,
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  index = (index + 1) % 60;
                  return ClockHandsList[index];
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ClockHands extends StatelessWidget {
  final int index;
  const ClockHands({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              height: index % 5 == 0 ? 80.0 : 25,
              width: 2.0,
              color: Colors.black,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                index % 5 == 0 ? index.abs().toString() : '',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
