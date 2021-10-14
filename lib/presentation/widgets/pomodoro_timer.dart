import 'package:flutter/material.dart';

class PomodoroTimer extends StatelessWidget {
  const PomodoroTimer({
    Key? key,
    required this.onSelectedItemChanged,
    required this.controller,
    required this.physics,
    required this.onListWheelTap,
    required this.onUserScroll,
  }) : super(key: key);
  final Function(int min) onSelectedItemChanged;
  final FixedExtentScrollController controller;
  final ScrollPhysics physics;
  final Function onListWheelTap;
  final bool Function(UserScrollNotification) onUserScroll;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: GestureDetector(
        onTap: () => onListWheelTap(),
        child: NotificationListener<UserScrollNotification>(
          onNotification: onUserScroll,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 40,
            squeeze: 2,
            diameterRatio: 1.3,
            physics: physics, //FixedExtentScrollPhysics(),
            onSelectedItemChanged: onSelectedItemChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                index = (index + 1) % 60;
                return RotatedBox(
                  quarterTurns: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          height: index % 5 == 0 ? 80.0 : 25,
                          width: 2.0,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            index % 5 == 0 ? index.abs().toString() : '',
                            style: TextStyle(
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
