import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

const _borderColor = Color.fromARGB(255, 255, 236, 179);

class ToDoTile extends StatelessWidget {
  // Colors
  final _tileBackgroundColor = const Color.fromARGB(255, 45, 45, 45);
  final _completedTileBackgroundColor = const Color.fromARGB(255, 15, 15, 15);
  final _starredCompletedTileBackgroundColor =
      const Color.fromARGB(255, 25, 25, 5);
  final _starredTileBackgroundColor = const Color.fromARGB(255, 45, 45, 10);
  final _commonTextColor = const Color.fromARGB(255, 255, 248, 225);
  final _completedTextColor = const Color.fromARGB(255, 100, 100, 100);
  final _lineThroughColor = const Color.fromARGB(255, 52, 52, 52);
  final _starBackgroundColor = const Color.fromARGB(255, 75, 75, 75);
  final _starForegroundColor = const Color.fromARGB(255, 255, 215, 0);
  final _deleteBackgroundColor = const Color.fromARGB(255, 255, 125, 125);
  final _deleteForegroundColor = const Color.fromARGB(255, 0, 0, 0);
  final _dueDateColor = const Color.fromARGB(255, 170, 165, 150);
  final _pastDueDateColor = const Color.fromARGB(255, 255, 125, 125);

  // DATA
  final bool value;
  final String task;
  final bool star;
  final DateTime? dueDate;
  final dynamic maxLines;

  final ValueChanged<bool?>? onChanged;
  final ValueChanged<bool?>? onStarred;
  final VoidCallback? onDelete;
  final Function? onTaskTap;
  final Function? onTaskLongPress;

  const ToDoTile({
    required this.value,
    required this.task,
    required this.star,
    required this.dueDate,
    required this.maxLines,
    required this.onChanged,
    required this.onStarred,
    required this.onDelete,
    required this.onTaskTap,
    required this.onTaskLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTaskTap!(maxLines),
      onLongPress: () => onTaskLongPress!(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Slidable(
            key: const ValueKey(0),
            endActionPane: ActionPane(
              extentRatio: 0.4,
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  autoClose: true,
                  backgroundColor: _starBackgroundColor,
                  foregroundColor: _starForegroundColor,
                  icon: star ? Icons.star : Icons.star_border,
                  onPressed: (context) => onStarred!(!star),
                ),
                SlidableAction(
                  autoClose: true,
                  backgroundColor: _deleteBackgroundColor,
                  foregroundColor: _deleteForegroundColor,
                  icon: Icons.delete_outlined,
                  onPressed: (context) => onDelete!(),
                ),
              ],
            ),
            child: Container(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 7),
              decoration: BoxDecoration(
                color: star
                    ? value
                        ? _starredCompletedTileBackgroundColor
                        : _starredTileBackgroundColor
                    : value
                        ? _completedTileBackgroundColor
                        : _tileBackgroundColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              decoration:
                                  value ? TextDecoration.lineThrough : null,
                              decorationColor: _lineThroughColor,
                              decorationThickness: 3,
                              color: value
                                  ? _completedTextColor
                                  : _commonTextColor),
                          maxLines: maxLines,
                          overflow:
                              maxLines != null ? TextOverflow.fade : null,
                          softWrap: true,
                        ),
                        if (dueDate != null)
                          Text(
                            "Due: ${dueDate!.day} ${DateFormat.MMM().format(dueDate!)}, ${dueDate!.year}",
                            style: TextStyle(
                              color: value
                                  ? _completedTextColor
                                  : dueDate!.difference(DateTime.now()).inDays <
                                          1
                                      ? _pastDueDateColor
                                      : _dueDateColor,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: value,
                      fillColor: WidgetStatePropertyAll(
                        star
                            ? value
                                ? _starredCompletedTileBackgroundColor
                                : _starredTileBackgroundColor
                            : value
                                ? _completedTileBackgroundColor
                                : _tileBackgroundColor,
                      ),
                      side: WidgetStateBorderSide.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return BorderSide(
                            width: 1.5,
                            color: star
                                ? _starredCompletedTileBackgroundColor
                                : _completedTileBackgroundColor,
                          );
                        }
                        return const BorderSide(
                          width: 1.5,
                          color: _borderColor,
                        );
                      }),
                      onChanged: (value) => onChanged!(value),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
