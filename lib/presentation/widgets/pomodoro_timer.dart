import 'package:flutter/material.dart';

class PomodoroTimer extends StatelessWidget {
  const PomodoroTimer(
      {Key? key, required this.updateTimer, required this.controller})
      : super(key: key);
  final Function(int min) updateTimer;
  final FixedExtentScrollController controller;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 40,
        squeeze: 2,
        diameterRatio: 1.3,
        physics: FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            index = (index + 1) % 60;
            return RotatedBox(
              quarterTurns: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: index % 5 == 0 ? 80.0 : 25,
                    width: 2.0,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      index % 5 == 0 ? index.abs().toString() : '',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}