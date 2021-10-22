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
  // For Counting the end index for Clock Turning Animation
  int minutesOnClock = 25;
  int listViewItemPosition = 24;
  bool isListIndexChange = true;
  final FixedExtentScrollController controller = FixedExtentScrollController(
    initialItem: 24,
  );

  @override
  void dispose() {
    controller.dispose();
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
              SizedBox(height: 80),
              Flexible(child: _SessionNameText()),
              _TimerText(),
              Flexible(
                flex: 2,
                child: PomodoroTimer(
                  controller: controller,
                  onSelectedItemChanged: onSelectedItemChanged,
                  onUserScroll: onUserScroll,
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: 95.5,
                  width: 300,
                  child: _Buttons(
                    turnTheClock: turnTheClock,
                  ),
                ),
              ),
              BlocListener<TimerBloc, TimerState>(
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
                  } else if (state is TimerRunStart) {
                    final item = state.timerModel.clockMinutes - 1;
                    print('JUMPED TO ITEM: $item');
                    controller.jumpToItem(state.timerModel.clockMinutes - 1);
                    turnTheClock(state.timerModel.duration);
                  }
                },
                child: Flexible(child: FocusSessionTable()),
              ),
              Flexible(child: ProgressBar()),
            ],
          ),
        ],
      ),
    );
  }

  bool onUserScroll(userScrollNotification) {
    print('-----------------  USER SCROLLS SEND EVENT  ----------------- ');
    if (userScrollNotification.direction.index > 0) {
      BlocProvider.of<TimerBloc>(context).add(UserScrolled());
    }
    return true;
  }

  onSelectedItemChanged(listPositionReal) {
    print('ON SELECTED ITEM CHANGED');
    BlocProvider.of<TimerBloc>(context)
        .add(SelectedItemChanged(clockMinutes: ((listPositionReal + 1) % 60)));

    listViewItemPosition = listPositionReal;
    // Flag that the current List index changed
    isListIndexChange = true;
    minutesOnClock = (listPositionReal + 1) % 60;
  }

  void turnTheClock(int durationInSeconds) {
    // Calculate the end position of the clock, taking into account that
    // the calculation is using the current index and the minutes count,
    // but when the clock starts it substracts 1 minute, so when user pause and
    // resume the calculation that is made is one index short of a goal.
    // Also take into account that the listViewItemPosition changes when seconds
    // reach 30.
    int endPosition = -1;
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
}

class _Buttons extends StatelessWidget {
  final Function turnTheClock;
  const _Buttons({
    Key? key,
    required this.turnTheClock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        _PlayButton(
          turnTheClock: turnTheClock,
        ),
        BlocBuilder<TimerBloc, TimerState>(
          buildWhen: (previous, current) {
            if (previous.timerModel.isFocus != current.timerModel.isFocus) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            return state.timerModel.isFocus ? Container() : _SkipButton();
          },
        ),
      ],
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
      buildWhen: (previous, current) {
        if (previous.timerModel.isFocus != current.timerModel.isFocus) {
          return true;
        } else {
          return false;
        }
      },
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
      flex: 2,
      child: BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (previous, current) {
          if (current is TimerInitial && !current.timerModel.isUserScroll) {
            return false;
          } else {
            return true;
          }
        },
        builder: (context, state) {
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
      buildWhen: (previous, current) {
        if (previous.timerModel.isFocus != current.timerModel.isFocus) {
          return true;
        } else {
          return false;
        }
      },
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
      buildWhen: (previous, current) {
        if ((previous.timerModel.isPaused != current.timerModel.isPaused) ||
            (previous.timerModel.duration != current.timerModel.duration) ||
            (previous.timerModel.isFocus != current.timerModel.isFocus)) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if ((state is TimerRunInProgress) || (state is TimerRunStart)) {
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
