import 'package:flutter/material.dart';

class FocusSessionTable extends StatelessWidget {
  final String focusSessionsCompleted;
  const FocusSessionTable({Key? key, required this.focusSessionsCompleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          'Today: $focusSessionsCompleted/12',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
