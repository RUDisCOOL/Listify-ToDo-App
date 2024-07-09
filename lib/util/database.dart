import 'package:hive_flutter/adapters.dart';

class Database {
  final box = Hive.box('myTasks');
  String selectedList = 'All Tasks';
  List<dynamic> toDoList = [];
  List<dynamic> allListNames = ['All Tasks'];

  void createInitialData() {
    if (selectedList == 'All Tasks') {
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
            'task':
                'Tasks which are marked as starred will show up at the top.',
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
    } else {
      toDoList = [
        {
          'task': 'Make new Task',
          'completed': false,
          'starred': true,
          'dueDate': null,
          'maxLines': null,
        },
      ];
    }
    box.put('List_Names', allListNames);
    box.put(selectedList, toDoList);
  }

  bool alreadyExists(String listName) {
    return allListNames.contains(listName);
  }

  void loadData() {
    toDoList = List<Map<dynamic, dynamic>>.from(box.get(selectedList) ?? []);
  }

  void loadLists() {
    allListNames = List<String>.from(box.get('List_Names') ?? ['All Tasks']);
  }

  void updateData() {
    box.put(selectedList, toDoList);
  }

  void updateLists() {
    box.put('List_Names', allListNames);
  }

  void editListName(index, newListName) {
    toDoList =
        List<Map<dynamic, dynamic>>.from(box.get(allListNames[index]) ?? []);
    deleteList(allListNames[index]);
    allListNames[index] = newListName;
    updateLists();
    box.put(newListName, toDoList);
  }

  void deleteList(String listName) {
    box.delete(listName);
  }
}
