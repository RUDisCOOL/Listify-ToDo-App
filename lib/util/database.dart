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
          'maxLines': 2,
        },
        {
          'task':
              'Tap me to reveal the message:\n\nTapping on a Task with multiple lines reveals the whole Task, especially useful when the Task is too Long',
          'completed': false,
          'starred': true,
          'dueDate': null,
          'maxLines': 2,
        },
        {
          'task':
              'This task has a Due-Date.\nYes, you need to finish this task until the timer runs out.\nYou can add a Due-Date to task while creating the task or by editing the task after you have created it.',
          'completed': false,
          'starred': false,
          'dueDate': DateTime.now().add(const Duration(days: 2)),
          'maxLines': 2,
        },
        {
          'task':
              '\'Get 2 litsre milk\' Made a typo!!\nDon\'t Worry I got you covered!!\nLong press a Task to edit a Task\'s property!!',
          'completed': false,
          'starred': false,
          'dueDate': null,
          'maxLines': 2,
        },
        {
          'task': 'Tasks which are marked as starred will show up at the top.',
          'completed': false,
          'starred': true,
          'dueDate': null,
          'maxLines': 2,
        },
        {
          'task': 'Try swiping a task from Right to Left.',
          'completed': false,
          'starred': true,
          'dueDate': null,
          'maxLines': 2,
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
