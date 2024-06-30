import 'package:flutter/material.dart';

class ToDoTile extends StatelessWidget {
  final bool value;
  final String task;
  final ValueChanged<bool?>? onChanged;

  const ToDoTile({
    required this.value,
    required this.task,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 34, right: 34, top: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
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
                      : Colors.amber[50]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: value,
              onChanged: (value) {
                if (onChanged != null) {
                  onChanged!(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
