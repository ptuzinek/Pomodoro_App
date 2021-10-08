import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_app/presentation/widgets/focus_session_table.dart';
import 'package:pomodoro_app/presentation/widgets/pomodoro_timer.dart';
import 'package:pomodoro_app/presentation/widgets/progress_bar.dart';
import 'package:pomodoro_app/state_managment/bloc/timer_bloc.dart';

class HomeScreenCubitBased extends StatefulWidget {
  const HomeScreenCubitBased({Key? key}) : super(key: key);

  @override
  _HomeScreenCubitBasedState createState() => _HomeScreenCubitBasedState();
}

class _HomeScreenCubitBasedState extends State<HomeScreenCubitBased> {
  int minutesOnClock = 25;
  //int seconds = 0;
  int listViewItemPosition = 24;
  int focusSessionsCompleted = 0;
  ScrollPhysics physics = FixedExtentScrollPhysics();
  // bool isPaused = true;
  // bool isFocus = true;
  // bool isLongBreak = false;
  bool isListIndexChange = true;
  // Color backgroundColor = Colors.white;
  final FixedExtentScrollController controller = FixedExtentScrollController(
    initialItem: 24,
  );

  @override
  void dispose() {
    controller.dispose();
    // timer?.cancel();
    // timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _Background(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 100),
              _SessionNameText(),
              SizedBox(height: 10),
              _TimerText(),
              Flexible(
                child: BlocListener<TimerBloc, TimerState>(
                  listener: (_, state) {
                    if (state is TimerRunComplete) {
                      if (state.timerModel.isFocus &&
                          ((state.timerModel.completedSessions + 1) % 4) != 0) {
                        controller.jumpToItem(4);
                        turnTheClock(state.timerModel.duration);
                      } else if ((state.timerModel.isFocus &&
                              ((state.timerModel.completedSessions + 1) % 4) ==
                                  0) ||
                          (!state.timerModel.isFocus)) {
                        controller.jumpToItem(24);
                        turnTheClock(state.timerModel.duration);
                      }
                    } else if (state is TimerRunPause) {
                      controller.animateTo(controller.offset,
                          duration: Duration(microseconds: 1),
                          curve: Curves.linear);
                    }
                  },
                  child: PomodoroTimer(
                    controller: controller,
                    physics: physics,
                    onListWheelTap: onListWheelTap,
                    onSelectedItemChanged: onSelectedItemChanged,
                    onUserScroll: onUserScroll,
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: _Buttons(
                  turnTheClock: turnTheClock,
                ),
              ),
              SizedBox(height: 50),
              FocusSessionTable(),
              SizedBox(height: 150),
              ProgressBar(),
            ],
          ),
        ],
      ),
    );
  }

  bool onUserScroll(userScrollNotification) {
    print('-----------------  USER SCROLLS SEND EVENT  ----------------- ');
    physics = FixedExtentScrollPhysics();
    BlocProvider.of<TimerBloc>(context).add(UserScrolled());

    // timer?.cancel();
    // setState(() {
    //   //seconds = 0;
    //   // isPaused = true;
    // });
    return true;
  }

  onSelectedItemChanged(listPositionReal) {
    print('ON SELECTED ITEM CHANGED');
    BlocProvider.of<TimerBloc>(context)
        .add(SelectedItemChanged(clockMinutes: ((listPositionReal + 1) % 60)));

    listViewItemPosition = listPositionReal;
    // Flag that the current List index changed
    isListIndexChange = true;
    // setState(() {
    minutesOnClock = (listPositionReal + 1) % 60;
    // });
  }

// ----------------------  THESE NEEDS TO STAY  -----------------------
  void turnTheClock(int durationInSeconds) {
    // Change Physics to stop the clock at the exact current position and not
    // the closest element.
    physics = AlwaysScrollableScrollPhysics();
    // final int durationInSeconds = minutesOnClock * 60 + seconds;

    // Calculate the end position of the clock, taking into account that
    // the calculation is using the current index and the minutes count,
    // but when the clock starts it substracts 1 minute, so when user pause and
    // resume the calculation that is made is one index short of a goal.
    // Also take into account that the listViewItemPosition changes when seconds
    // reach 30.
    int endPosition = -1;
    // // here we take into account that the minute should be rounded up.
    if (isListIndexChange) {
      endPosition = listViewItemPosition - minutesOnClock;
    } else {
      endPosition = listViewItemPosition - minutesOnClock - 1;
    }

    print('END POSITION: $endPosition');

    controller.animateToItem((endPosition),
        duration: Duration(
          seconds: durationInSeconds > 0 ? durationInSeconds : 1,
        ),
        curve: Curves.linear);
  }

  void pauseCountdownAndRotation() {
    // timer?.cancel();
    print('PAUSE');
    // Interrupt the animation by creating new one to the current position.
    controller.animateTo(controller.offset,
        duration: Duration(microseconds: 1), curve: Curves.linear);
    // setState(() {
    //   isPaused = true;
    // });
  }

  void onListWheelTap() {
    // if (isPaused) {
    //   //turnTheClock();
    // } else {
    //   // timer?.cancel();
    //   setState(() {
    //     isPaused = true;
    //   });
    // }
  }
}

class _Buttons extends StatelessWidget {
  final Function turnTheClock;
  const _Buttons({
    Key? key,
    required this.turnTheClock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            _PlayButton(
              turnTheClock: turnTheClock,
            ),
            state.timerModel.isFocus ? Container() : _SkipButton(),
          ],
        );
      },
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          iconSize: 35,
          onPressed: () {
            print('SKIP BUTTON PRESSED');

            BlocProvider.of<TimerBloc>(context).add(BreakSkipped());
            //timer?.cancel();
            // setState(() {
            // backgroundColor = Colors.white;
            // Change the session, rotate the clock to starting position,
            // reset the clock.
            //isFocus = !isFocus;
            //controller.jumpToItem(24);
            //minutes = 25;
            //seconds = 0;

            //turnTheClock();
            // });
            print('Skipped the Break');
          },
          icon: Icon(
            Icons.skip_next,
          ),
        ),
      ),
    );
  }
}

class _SessionNameText extends StatelessWidget {
  const _SessionNameText();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Text(
          state.timerModel.isFocus ? 'Focus' : 'Break',
          style: TextStyle(
            fontSize: 20,
          ),
        );
      },
    );
  }
}

class _TimerText extends StatelessWidget {
  const _TimerText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (previous, current) {
          if (current is TimerInitial && !current.timerModel.isUserScroll) {
            return false;
          } else {
            return true;
          }
        },
        builder: (context, state) {
          print(
              '------------------------  TEXT CHANGE ! ------------------------');
          if (state is TimerInitial) {
            return Text(
              displayTime(state.timerModel.clockMinutes * 60),
              style: TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 75,
              ),
            );
          } else {
            return Text(
              displayTime(state.timerModel.duration),
              style: TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 75,
              ),
            );
          }
        },
      ),
    );
  }

  String displayTime(int duration) {
    final minutes = ((duration / 60) % 60).floor();
    final seconds = (duration % 60).floor();
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
}

class _Background extends StatelessWidget {
  const _Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 400),
          color: state.timerModel.isFocus ? Colors.white : Colors.lightGreen,
        );
      },
    );
  }
}

class _PlayButton extends StatelessWidget {
  final Function turnTheClock;
  const _PlayButton({Key? key, required this.turnTheClock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        if (state is TimerRunInProgress) {
          return IconButton(
            iconSize: 40,
            icon: Icon(
              Icons.pause,
            ),
            onPressed: () {
              print('PAUSE BUTTON PRESSED');

              BlocProvider.of<TimerBloc>(context).add(TimerPaused());
            },
          );
        } else if (state is TimerInitial) {
          return IconButton(
            iconSize: 40,
            icon: Icon(
              Icons.play_arrow,
            ),
            onPressed: () {
              print('PLAY BUTTON PRESSED');

              BlocProvider.of<TimerBloc>(context)
                  .add(TimerStarted(timerModel: state.timerModel));
              turnTheClock(state.timerModel.duration);
            },
          );
        } else if (state is TimerRunPause) {
          return IconButton(
            iconSize: 40,
            icon: Icon(
              Icons.play_arrow,
            ),
            onPressed: () {
              print('RESUME BUTTON PRESSED');

              BlocProvider.of<TimerBloc>(context).add(TimerResumed());
              turnTheClock(state.timerModel.duration);
            },
          );
        } else {
          return Container(
            child: Text('OH NO!'),
          );
        }
      },
    );
  }
}
