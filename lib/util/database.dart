import 'package:hive_flutter/adapters.dart';

class Database {
  final box = Hive.box('myTasks');
  List<dynamic> toDoList = [];

  void createInitialData() {
    toDoList.addAll(
      [
        {
          'task': 'Make new Task',
          'completed': false,
          'starred': true,
          'dueDate': null,
          'maxLines': null,
        },
        {
          'task':
              'Feel like the Task is too Long.\n\nTap the task to reduce the size of task.\nThis is especially helpful when the task is too Long.',
          'completed': false,
          'starred': true,
          'dueDate': null,
          'maxLines': null,
        },
        {
          'task':
              'This task has a Due-Date.\n\nYes, you need to finish this task until the timer runs out.\nYou can add a Due-Date to task while creating the task or by editing the task after you have created it.',
          'completed': false,
          'starred': false,
          'dueDate': DateTime.now().add(const Duration(days: 2)),
          'maxLines': null,
        },
        {
          'task':
              'Made a typo!! Don\'t Worry I got you covered!!\nLong press a Task to edit a Task\'s property!!',
          'completed': false,
          'starred': false,
          'dueDate': null,
          'maxLines': null,
        },
        {
          'task': 'Tasks which are marked as starred will show up at the top.',
          'completed': false,
          'starred': true,
          'dueDate': null,
          'maxLines': null,
        },
        {
          'task': 'Try swiping a task from Right to Left.',
          'completed': false,
          'starred': true,
          'dueDate': null,
          'maxLines': null,
        },
      ],
    );
    box.put('ToDoList', toDoList);
  }

  void loadData() {
    toDoList = box.get('ToDoList');
  }

  void updateData() {
    box.put('ToDoList', toDoList);
  }
}
