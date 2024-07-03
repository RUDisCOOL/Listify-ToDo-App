import 'package:hive_flutter/adapters.dart';

class Database {
  final box = Hive.box('myTasks');
  List<dynamic> toDoList = [];

  void createInitialData() {
    toDoList.add(
      {
        'task': 'Make new Task',
        'completed': false,
        'starred': false,
        'dueDate': null,
        'maxLines': null,
      },
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
