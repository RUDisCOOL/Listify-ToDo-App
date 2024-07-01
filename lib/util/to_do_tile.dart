import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final bool value;
  final String task;
  final bool star;
  final ValueChanged<bool?>? onChanged;
  final ValueChanged<bool?>? onStarred;
  final VoidCallback? onDelete;

  const ToDoTile({
    required this.value,
    required this.task,
    required this.star,
    this.onChanged,
    this.onStarred,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                // backgroundColor: const Color.fromARGB(255, 255, 224, 130),
                backgroundColor: const Color.fromARGB(255, 75, 75, 75),
                foregroundColor: const Color.fromARGB(255, 255, 215, 0),
                icon: star ? Icons.star : Icons.star_border,
                onPressed: (context) => onStarred!(!star),
              ),
              SlidableAction(
                autoClose: true,
                backgroundColor: const Color.fromARGB(255, 255, 130, 130),
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
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
                      ? const Color.fromARGB(255, 13, 13, 7)
                      : const Color.fromARGB(255, 25, 25, 10)
                  : Theme.of(context).cardColor,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    task,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        decoration: value ? TextDecoration.lineThrough : null,
                        decorationThickness: 3,
                        color: value
                            ? const Color.fromARGB(255, 100, 100, 100)
                            : const Color.fromARGB(255, 255, 248, 225)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: value,
                    fillColor: WidgetStatePropertyAll(
                      star
                          ? value
                              ? const Color.fromARGB(255, 13, 13, 7)
                              : const Color.fromARGB(255, 25, 25, 10)
                          : Theme.of(context).cardColor,
                    ),
                    side: WidgetStateBorderSide.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return BorderSide(
                          width: 1.5,
                          color: star
                              ? const Color.fromARGB(255, 13, 13, 7)
                              : Theme.of(context).cardColor,
                        );
                      }
                    }),
                    onChanged: (value) => onChanged!(value),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
