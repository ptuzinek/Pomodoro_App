import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_app/state_managment/bloc/timer_bloc.dart';

class FocusSessionTable extends StatelessWidget {
  const FocusSessionTable();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocBuilder<TimerBloc, TimerState>(
          buildWhen: (previous, current) {
            if(previous.timerModel.completedSessions != current.timerModel.completedSessions) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            return Text(
              'Today: ${state.timerModel.completedSessions}/12',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            );
          },
        ),
      ),
    );
  }
}
