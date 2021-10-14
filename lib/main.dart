import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro_app/presentation/screens/home_screen.dart';
import 'package:pomodoro_app/presentation/screens/home_screen_cubit_based.dart';
import 'package:pomodoro_app/state_managment/bloc/timer_bloc.dart';

import 'data/ticker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(ticker: Ticker()),
      child: MaterialApp(
        showPerformanceOverlay: true,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreenCubitBased(),
      ),
    );
  }
}
