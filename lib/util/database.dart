import 'package:hive_flutter/adapters.dart';

class Database {
  final box = Hive.box('myTasks');
  List<Map<String, dynamic>> toDoList = [];

  void createInitialData() {
    toDoList.add(
      {
        'task': 'Make new Task',
        'completed': false,
      },
    );
    box.put('ToDoList', toDoList);
  }

  void loadData() {
    List<dynamic> rawList = box.get('ToDoList');
    toDoList = rawList.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  void updateData() {
    box.put('ToDoList', toDoList);
  }
}
