import 'package:flutter/material.dart';

class progressBar extends StatelessWidget {
  final progress;
  final length;

  const progressBar({super.key, required this.progress, required this.length});

  @override
  Widget build(BuildContext context) {
    const double height = 0.008;
    Duration duration = Duration(seconds: 0, milliseconds: (4000 / length).toInt());
    int indicator() {
      int ind;
      if (progress <= 0.0125) {
        ind = 0;
      } else {
        ind = 1;
      }
      return ind;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
      Material(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.green,
        child: Row(
          children: [
            AnimatedContainer(
              duration: duration,
              height: MediaQuery.of(context).size.height * height,
              width: MediaQuery.of(context).size.width * progress * 0.8 -
                  MediaQuery.of(context).size.width * 0.01 * indicator(),
            ),
            Material(
              elevation: 5,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: AnimatedContainer(
                duration: duration,
                height: MediaQuery.of(context).size.height * height,
                width: MediaQuery.of(context).size.width * 0.01,
              ),
            ),
            Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                color: Colors.red.shade400,
                child: AnimatedContainer(
                  duration: duration,
                  height: MediaQuery.of(context).size.height * height,
                  width:
                      MediaQuery.of(context).size.width * 0.8 * (1 - progress),
                ))
          ],
        ),
      )
    ]);
  }
}
