import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PoolHabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;
  final inProgressStatus;

  const PoolHabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.settingsTapped,
    required this.deleteTapped,
    required this.inProgressStatus,
  });

  @override
  Widget build(BuildContext context) {
    Color changeTileColor() {
      if (inProgressStatus) {
        return Colors.green.shade200;
      }
      return Colors.grey.shade100;
    }

    double inProgressPaddingFactor() {
      if (inProgressStatus) {
        return 1.2;
      }
      return 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // settings option
            SlidableAction(
              onPressed: settingsTapped,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(12),
            ),

            // delete option
            SlidableAction(
              onPressed: deleteTapped,
              backgroundColor: Colors.red.shade400,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Material(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
                horizontal: 20 * inProgressPaddingFactor(),
                vertical: 20 * inProgressPaddingFactor()),
            decoration: BoxDecoration(
                color: changeTileColor(),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100)),
            child: Row(
              children: [
                // checkbox
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    value: habitCompleted,
                    onChanged: onChanged,
                  ),
                ),
                Container(
                  width: 10,
                ),

                // habit name
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habitName
                          .replaceAll('\n', ' ')
                          .padRight(20, ' ')
                          .substring(0, 20),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.keyboard_double_arrow_left_outlined)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
