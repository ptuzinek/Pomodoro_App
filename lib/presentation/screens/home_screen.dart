import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/presentation/widgets/focus_session_table.dart';
import 'package:pomodoro_app/presentation/widgets/pomodoro_timer.dart';
import 'package:pomodoro_app/presentation/widgets/progress_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int minutes = 25;
  int seconds = 0;
  int listViewItemPosition = 24;
  int focusSessionsCompleted = 0;
  ScrollPhysics physics = FixedExtentScrollPhysics();
  Timer? timer;
  bool isPaused = true;
  bool isFocus = true;
  bool isLongBreak = false;
  bool isListIndexChange = true;
  final FixedExtentScrollController controller = FixedExtentScrollController(
    initialItem: 24,
  );

  @override
  void dispose() {
    controller.dispose();
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isFocus ? Colors.white : Colors.lightGreen,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              isFocus ? 'Focus' : 'Break',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
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
                onListWheelTap: onListWheelTap,
                onSelectedItemChanged: onSelectedItemChanged,
                onNotification: onNotification,
              ),
            ),
            SizedBox(
              width: 300,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  IconButton(
                    iconSize: 40,
                    icon: isPaused
                        ? Icon(
                            Icons.play_arrow,
                          )
                        : Icon(
                            Icons.pause,
                          ),
                    onPressed: () {
                      if (isPaused) {
                        startCountdown();
                        turnTheClock();
                      } else {
                        pauseCountdownAndRotation();
                      }
                    },
                  ),
                  isFocus
                      ? Container()
                      : Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              iconSize: 35,
                              onPressed: () {
                                timer?.cancel();
                                setState(() {
                                  // Change the session, rotate the clock to starting position,
                                  // reset the clock.
                                  isFocus = !isFocus;
                                  controller.jumpToItem(24);
                                  minutes = 25;
                                  seconds = 0;

                                  startCountdown();
                                  turnTheClock();
                                });
                                print('Skipped the Break');
                              },
                              icon: Icon(
                                Icons.skip_next,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            FocusSessionTable(
              focusSessionsCompleted: focusSessionsCompleted.toString(),
            ),
            SizedBox(
              height: 200,
              child: ProgressBar(
                progress: focusSessionsCompleted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool onNotification(userScrollNotification) {
    physics = FixedExtentScrollPhysics();
    timer?.cancel();
    setState(() {
      seconds = 0;
      isPaused = true;
    });
    return true;
  }

  onSelectedItemChanged(listPositionReal) {
    listViewItemPosition = listPositionReal;
    // Flag that the current List index changed
    isListIndexChange = true;
    setState(() {
      minutes = (listPositionReal + 1) % 60;
    });
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

    // Calculate the end position of the clock, taking into account that
    // the calculation is using the current index and the minutes count,
    // but when the clock starts it substracts 1 minute, so when user pause and
    // resume the calculation that is made is one index short of a goal.
    // Also take into account that the listViewItemPosition changes when seconds
    // reach 30.
    int endPosition = -1;
    // here we take into account that the minute should be rounded up.
    if (isListIndexChange) {
      endPosition = listViewItemPosition - minutes;
    } else {
      endPosition = listViewItemPosition - minutes - 1;
    }

    controller.animateToItem((endPosition),
        duration: Duration(
          seconds: durationInSeconds > 0 ? durationInSeconds : 1,
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
        setState(() {
          if (isFocus) {
            focusSessionsCompleted++;
          }
          // Change the session, rotate the clock to starting position,
          // reset the clock.

          isFocus = !isFocus;
          if (isFocus) {
            controller.jumpToItem(24);
            minutes = 25;
          } else if (!isFocus && (focusSessionsCompleted % 4) == 0) {
            controller.jumpToItem(24);
            minutes = 25;
          } else {
            controller.jumpToItem(4);
            minutes = 5;
          }

          startCountdown();
          turnTheClock();
        });
        print('Cancel in startCountdown');
      } else if (seconds == 0 && minutes != 0) {
        minutes--;
        seconds--;
        isListIndexChange = false;
      } else {
        seconds--;
      }
      setState(() {
        seconds = (seconds) % 60;
      });
    });
  }

  void pauseCountdownAndRotation() {
    timer?.cancel();
    print('PAUSE');
    // Interrupt the animation by creating new one to the current position.
    controller.animateTo(controller.offset,
        duration: Duration(microseconds: 1), curve: Curves.linear);
    setState(() {
      isPaused = true;
    });
  }

  void onListWheelTap() {
    if (isPaused) {
      startCountdown();
      turnTheClock();
    } else {
      timer?.cancel();
      setState(() {
        isPaused = true;
      });
    }
  }
}
