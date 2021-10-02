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
            Expanded(
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
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                turnTheClock();
                startCountdown();
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
    physics = AlwaysScrollableScrollPhysics();
    controller.animateToItem((listViewItemPosition - minutes),
        duration: Duration(
          minutes: minutes,
        ),
        curve: Curves.linear);
  }

  void startCountdown() {
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
}
