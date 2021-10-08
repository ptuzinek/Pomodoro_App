import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_app/state_managment/bloc/timer_bloc.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return getContainers(constraints);
    });
  }

  Row getContainers(BoxConstraints constraints) {
    List<Widget> list = [];
    for (int i = 0; i < 12; i++) {
      list.add(
        SizedBox(
          child: BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              return Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    height: 20,
                    width: constraints.maxWidth / 12,
                    decoration: BoxDecoration(
                      color: i < state.timerModel.completedSessions
                          ? Colors.black
                          : Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                  i < state.timerModel.completedSessions
                      ? Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.remove, size: 15),
                        ),
                ],
              );
            },
          ),
        ),
      );
    }
    return Row(
      children: list,
    );
  }
}
