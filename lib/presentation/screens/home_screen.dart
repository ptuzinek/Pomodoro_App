import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_app/presentation/widgets/pomodoro_timer.dart';
import 'package:pomodoro_app/state_managment/cubit/timer_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int minutes = 25;
  int seconds = 0;
  int listViewItemPosition = 24;
  ScrollPhysics physics = FixedExtentScrollPhysics();
  late Timer timer;
  bool isPaused = true;
  final FixedExtentScrollController controller = FixedExtentScrollController(
    initialItem: 24,
  );

  @override
  void dispose() {
    controller.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100,
            ),
            Flexible(
              child: Text(
                displayTime(),
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 75,
                ),
              ),
            ),
            Flexible(
              child: PomodoroTimer(
                controller: controller,
                physics: physics,
                updateTimer: (listPositionReal) {
                  listViewItemPosition = listPositionReal;
                  setState(() {
                    minutes = (listPositionReal + 1) % 60;
                  });
                },
              ),
            ),
            IconButton(
              icon: isPaused ? Icon(Icons.play_arrow) : Icon(Icons.pause),
              onPressed: () {
                if (isPaused) {
                  startCountdown();
                  turnTheClock();
                } else {
                  pauseTheClock();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String displayTime() {
    if (seconds == 60) {
      return '$minutes:00';
    } else if (minutes > 9 && seconds > 9) {
      return '$minutes:$seconds';
    } else if (minutes < 10 && seconds < 10) {
      return '0$minutes:0$seconds';
    } else if (minutes < 10 && seconds > 9) {
      return '0$minutes:$seconds';
    } else if (minutes > 9 && seconds < 10) {
      return '$minutes:0$seconds';
    } else {
      return '';
    }
  }

  void turnTheClock() {
    // Change Physics to stop the clock at the exact current position and not
    // the closest element.
    physics = AlwaysScrollableScrollPhysics();
    final int durationInSeconds = minutes * 60 + seconds;

    controller.animateToItem((listViewItemPosition - minutes),
        duration: Duration(
          seconds: durationInSeconds,
        ),
        curve: Curves.linear);
  }

  void startCountdown() {
    setState(() {
      isPaused = false;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds == 0 && minutes == 0) {
        timer.cancel();
        print('Cancel in startCountdown');
      } else if (seconds == 0 && minutes != 0) {
        minutes--;
        seconds--;
      } else {
        seconds--;
      }
      setState(() {
        seconds = (seconds) % 60;
      });
    });
  }

  void pauseTheClock() {
    timer.cancel();
    print('PAUSE');
    // Interrupt the animation by creating new one to the current position.
    controller.animateTo(controller.offset,
        duration: Duration(microseconds: 1), curve: Curves.linear);
    setState(() {
      isPaused = true;
    });
  }
}
