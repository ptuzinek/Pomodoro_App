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
  final FixedExtentScrollController controller = FixedExtentScrollController(
    initialItem: 24,
  );

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
                '25:00',
                style: TextStyle(fontSize: 75),
              ),
            ),
            Expanded(
              child: PomodoroTimer(
                controller: controller,
                updateTimer: (min) {
                  setState(() {
                    minutes = min;
                    seconds = 0;
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
