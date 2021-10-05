import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int progress;
  const ProgressBar({Key? key, required this.progress}) : super(key: key);

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
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: 20,
                width: constraints.maxWidth / 12,
                decoration: BoxDecoration(
                  color: i < progress ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
              i < progress
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
                      child: Icon(Icons.remove, size: 15)),
            ],
          ),
        ),
      );
    }
    return Row(
      children: list,
    );
  }
}
