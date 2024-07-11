import 'package:hive_flutter/adapters.dart';
import 'package:uuid/v4.dart';

class Database {
  UuidV4 uuid = const UuidV4();
  final box = Hive.box('myTasks');
  String selectedList = 'All Tasks';
  List<dynamic> toDoList = [];
  List<dynamic> allListNames = ['All Tasks'];

  void createInitialData() {
    if (selectedList == 'All Tasks') {
      toDoList.addAll(
        [
          {
            'id': uuid.generate(),
            'task': 'Make new Task',
            'listName': 'All Tasks',
            'completed': false,
            'starred': true,
            'dueDate': null,
            'maxLines': null,
          },
          {
            'id': uuid.generate(),
            'task':
                'Feel like the Task is too Long.\n\nTap the task to reduce the size of task.\nThis is especially helpful when the task is too Long.',
            'listName': 'All Tasks',
            'completed': false,
            'starred': true,
            'dueDate': null,
            'maxLines': null,
          },
          {
            'id': uuid.generate(),
            'task':
                'This task has a Due-Date.\n\nYes, you need to finish this task until the timer runs out.\nYou can add a Due-Date to task while creating the task or by editing the task after you have created it.',
            'listName': 'All Tasks',
            'completed': false,
            'starred': false,
            'dueDate': DateTime.now().add(const Duration(days: 2)),
            'maxLines': null,
          },
          {
            'id': uuid.generate(),
            'task':
                'Made a typo!! Don\'t Worry I got you covered!!\nLong press a Task to edit a Task\'s property!!',
            'listName': 'All Tasks',
            'completed': false,
            'starred': false,
            'dueDate': null,
            'maxLines': null,
          },
          {
            'id': uuid.generate(),
            'task':
                'Tasks which are marked as starred will show up at the top.',
            'listName': 'All Tasks',
            'completed': false,
            'starred': true,
            'dueDate': null,
            'maxLines': null,
          },
          {
            'id': uuid.generate(),
            'task': 'Try swiping a task from Right to Left.',
            'listName': 'All Tasks',
            'completed': false,
            'starred': true,
            'dueDate': null,
            'maxLines': null,
          },
        ],
      );
    } else {
      toDoList = [];
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

  void addToAllTasks(data) {
    List<dynamic> tempList = box.get('All Tasks');
    tempList.add(data);
    box.put('All Tasks', tempList);
  }

  void deleteFromAllTasks(id) {
    List<dynamic> tempList = box.get('All Tasks');
    tempList.removeWhere((task) => task['id'] == id);
    box.put('All Tasks', tempList);
  }

  void deleteFromList(listName, id) {
    List<dynamic> tempList = box.get(listName);
    tempList.removeWhere((task) => task['id'] == id);
    box.put(listName, tempList);
  }

  void editFromAllTasks(String task, bool starred, DateTime? dueDate, id) {
    List<dynamic> tempList = box.get('All Tasks');
    final index = tempList.indexWhere((element) => element['id'] == id);
    tempList[index]['task'] = task;
    tempList[index]['completed'] = false;
    tempList[index]['starred'] = starred;
    tempList[index]['dueDate'] = dueDate;
    tempList[index]['maxLines'] = null;
    box.put('All Tasks', tempList);
  }

  void editFromList(
      String task, bool starred, DateTime? dueDate, listName, id) {
    List<dynamic> tempList = box.get(listName);
    final index = tempList.indexWhere((element) => element['id'] == id);
    tempList[index]['task'] = task;
    tempList[index]['completed'] = false;
    tempList[index]['starred'] = starred;
    tempList[index]['dueDate'] = dueDate;
    tempList[index]['maxLines'] = null;
    box.put(listName, tempList);
  }

  void starFromAllTasks(bool star, id) {
    List<dynamic> tempList = box.get('All Tasks');
    final index = tempList.indexWhere((task) => task['id'] == id);
    tempList[index]['starred'] = star;
    box.put('All Tasks', tempList);
  }

  void starFromList(bool star, listName, id) {
    List<dynamic> tempList = box.get(listName);
    final index = tempList.indexWhere((task) => task['id'] == id);
    tempList[index]['starred'] = star;
    box.put(listName, tempList);
  }

  void checkFromAllTasks(bool? value, id) {
    List<dynamic> tempList = box.get('All Tasks');
    final index = tempList.indexWhere((task) => task['id'] == id);
    tempList[index]['completed'] = value;
    box.put('All Tasks', tempList);
  }

  void checkFromList(bool? value, listName, id) {
    List<dynamic> tempList = box.get(listName);
    final index = tempList.indexWhere((task) => task['id'] == id);
    tempList[index]['completed'] = value;
    box.put(listName, tempList);
  }

  void updateData() {
    box.put(selectedList, toDoList);
  }

  void updateLists() {
    box.put('List_Names', allListNames);
  }

  void editListName(index, newListName) {
    final oldListName = allListNames[index];
    List<dynamic> tempList = box.get(oldListName);
    List<dynamic> tempAllTaskList = box.get('All Tasks');
    box.delete(oldListName);
    for (int index = 0; index < tempList.length; index++) {
      tempList[index]['listName'] = newListName;
    }
    for (int index = 0; index < tempAllTaskList.length; index++) {
      if (tempAllTaskList[index]['listName'] == oldListName) {
        tempAllTaskList[index]['listName'] = newListName;
      }
    }
    allListNames[index] = newListName;
    updateLists();
    box.put(newListName, tempList);
    box.put('All Tasks', tempAllTaskList);
  }

  void deleteList(String listName) {
    List<dynamic> tempList = box.get('All Tasks');
    for (int index = 0; index < tempList.length; index++) {
      if (tempList[index]['listName'] == listName) {
        deleteFromAllTasks(tempList[index]['id']);
        index--;
      }
    }
    allListNames.remove(listName);
    updateLists();
    box.delete(listName);
  }
}
