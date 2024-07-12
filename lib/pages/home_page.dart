import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/util/list_name_tile.dart';
import 'package:to_do_app/util/to_do_tile.dart';
import 'package:to_do_app/util/database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:uuid/v4.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Colors
  final _textInputColor = const Color.fromARGB(255, 255, 248, 225);
  final _starForegroundColor = const Color.fromARGB(255, 255, 215, 0);
  final _calendarIconColor = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 255, 248, 225),
    brightness: Brightness.dark,
  ).primary;

  final textController = TextEditingController();
  UuidV4 uuid = const UuidV4();
  Box box = Hive.box('myTasks');
  Database db = Database();
  DateTime? dueDate;
  DateTime? pickedDate;
  String selectedList = 'All Tasks';

  void setSelectedList(String selectedListName) {
    setState(() {
      selectedList = selectedListName;
      db.selectedList = selectedListName;
      if (box.get(db.selectedList) == null) {
        db.createInitialData();
      } else {
        db.loadData();
      }
      _sortToDoList();
    });
    Navigator.of(context).pop();
  }

  void _inputOrEditListName({index}) {
    textController.clear();
    String listName;
    String? errorName;
    if (index != null) {
      textController.text = db.allListNames[index];
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: TextField(
              autofocus: true,
              controller: textController,
              maxLength: 16,
              decoration: InputDecoration(
                hintText: 'Enter the a new list-name',
                errorText: errorName,
              ),
              onChanged: (listName) => {
                setState(() {
                  if (db.alreadyExists(listName.trim())) {
                    errorName = 'List already exists';
                  } else {
                    errorName = null;
                  }
                })
              },
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  listName = textController.text.trim();
                  if (!db.alreadyExists(listName)) {
                    if (index != null && listName.isNotEmpty) {
                      _editListName(index, listName);
                    } else if (listName.isNotEmpty) {
                      _createNewList(listName);
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              )
            ],
          );
        });
      },
    );
  }

  void _createNewList(String listName) {
    setState(() {
      db.allListNames.add(listName);
      db.updateLists();
    });
  }

  void _editListName(index, String newListName) {
    setState(() {
      db.editListName(index, newListName);
      setSelectedList(newListName);
    });
  }

  void _deleteList(index) {
    setState(() {
      db.deleteList(db.allListNames[index]);
      setSelectedList('All Tasks');
    });
  }

  void _sortToDoList() {
    List<Map<dynamic, dynamic>> starredTasks = [];
    List<Map<dynamic, dynamic>> completedStarredTasks = [];
    List<Map<dynamic, dynamic>> completedTasks = [];
    List<Map<dynamic, dynamic>> uncompletedTasks = [];
    List<Map<dynamic, dynamic>> dueDateTasks = [];

    for (var task in db.toDoList) {
      if (task['completed'] == true) {
        if (task['starred'] == true) {
          completedStarredTasks.add(task);
        } else {
          completedTasks.add(task);
        }
      } else if (task['starred'] == true) {
        starredTasks.add(task);
      } else if (task['dueDate'] != null) {
        dueDateTasks.add(task);
      } else {
        uncompletedTasks.add(task);
      }
    }
    db.toDoList = starredTasks +
        dueDateTasks +
        uncompletedTasks +
        completedStarredTasks +
        completedTasks;
  }

  void _toggleTask(int index, bool? value) {
    setState(() {
      final listName = db.toDoList[index]['listName'];
      final id = db.toDoList[index]['id'];
      if (selectedList != 'All Tasks' && listName != 'All Tasks') {
        db.checkFromAllTasks(value, id);
      } else if (selectedList == 'All Tasks' && listName != selectedList) {
        db.checkFromList(value, listName, id);
      }
      db.toDoList[index]['completed'] = value!;
      _sortToDoList();
      db.updateData();
    });
  }

  void _toggleStar(int index, bool star) {
    setState(() {
      final listName = db.toDoList[index]['listName'];
      final id = db.toDoList[index]['id'];
      if (selectedList != 'All Tasks' && listName != 'All Tasks') {
        db.starFromAllTasks(star, id);
      } else if (selectedList == 'All Tasks' && listName != selectedList) {
        db.starFromList(star, listName, id);
      }
      db.toDoList[index]['starred'] = star;
      _sortToDoList();
      db.updateData();
    });
  }

  void _addTask(String task, bool starred, DateTime? dueDate) {
    setState(() {
      var id = uuid.generate();
      db.toDoList.add({
        'id': id,
        'task': task,
        'completed': false,
        'starred': starred,
        'dueDate': dueDate,
        'maxLines': null,
        'listName': selectedList,
      });
      if (selectedList != 'All Tasks') {
        db.addToAllTasks({
          'id': id,
          'task': task,
          'completed': false,
          'starred': starred,
          'dueDate': dueDate,
          'maxLines': null,
          'listName': selectedList,
        });
      }
      _sortToDoList();
      db.updateData();
    });
    textController.clear();
  }

  void _editTask(String task, bool starred, DateTime? dueDate, index) {
    setState(() {
      final listName = db.toDoList[index]['listName'];
      final id = db.toDoList[index]['id'];
      if (selectedList != 'All Tasks' && listName != 'All Tasks') {
        db.editFromAllTasks(task, starred, dueDate, id);
      } else if (selectedList == 'All Tasks' && listName != selectedList) {
        db.editFromList(task, starred, dueDate, listName, id);
      }
      db.toDoList[index]['task'] = task;
      db.toDoList[index]['completed'] = false;
      db.toDoList[index]['starred'] = starred;
      db.toDoList[index]['dueDate'] = dueDate;
      db.toDoList[index]['maxLines'] = null;
      _sortToDoList();
      db.updateData();
    });
    textController.clear();
  }

  void _deleteTask(index) {
    setState(() {
      final listName = db.toDoList[index]['listName'];
      final id = db.toDoList[index]['id'];
      if (selectedList != 'All Tasks' && listName != 'All Tasks') {
        db.deleteFromAllTasks(id);
      } else if (selectedList == 'All Tasks' && listName != selectedList) {
        db.deleteFromList(listName, id);
      }
      db.toDoList.removeAt(index);
      _sortToDoList();
      db.updateData();
    });
  }

  void _toggleMaxLines(int index, int? maxLines) {
    setState(() {
      db.toDoList[index]['maxLines'] = (maxLines != null) ? null : 2;
      db.updateData();
    });
  }

  void _showTaskInputEditField({index}) {
    bool starred;
    textController.clear();

    if (index != null) {
      starred = db.toDoList[index]['starred'];
      dueDate = db.toDoList[index]['dueDate'];
      textController.value = TextEditingValue(text: db.toDoList[index]['task']);
    } else {
      starred = false;
      dueDate = null;
    }
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      context: context,
      elevation: 5,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          void showDueDatePicker() async {
            pickedDate = await showDatePicker(
              helpText: 'Due Date',
              context: context,
              initialDate: pickedDate,
              firstDate: DateTime(DateTime.now().year - 5),
              lastDate: DateTime(DateTime.now().year + 5),
            );
            setModalState(() {
              dueDate = pickedDate;
            });
          }

          return Padding(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
              top: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom + 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autocorrect: true,
                  autofocus: true,
                  style: TextStyle(color: _textInputColor),
                  decoration: const InputDecoration(
                    hintText: 'Enter a new task',
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (dueDate != null) ...[
                      GestureDetector(
                        onTap: showDueDatePicker,
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 5,
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Color.fromARGB(255, 45, 45, 45),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Due: ${dueDate!.day} ${DateFormat.MMM().format(dueDate!)}, ${dueDate!.year}",
                                style: TextStyle(
                                  color: _textInputColor,
                                  fontSize: 15,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setModalState(
                                    () {
                                      dueDate = null;
                                    },
                                  );
                                },
                                padding: const EdgeInsets.all(0),
                                icon: const Icon(Icons.close),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                setModalState(() {
                                  starred = !starred;
                                });
                              },
                              icon: Icon(
                                starred ? Icons.star : Icons.star_border,
                                color: starred
                                    ? _starForegroundColor
                                    : _calendarIconColor,
                              ),
                            ),
                            IconButton(
                              onPressed: showDueDatePicker,
                              icon: Icon(
                                (dueDate == null)
                                    ? Icons.calendar_today_outlined
                                    : Icons.calendar_today_rounded,
                                color: _calendarIconColor,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (textController.text.trim().isNotEmpty) {
                              if (index != null) {
                                _editTask(textController.text.trim(), starred,
                                    dueDate, index);
                              } else {
                                _addTask(textController.text.trim(), starred,
                                    dueDate);
                              }
                            } else if (index != null) {
                              _deleteTask(index);
                            }
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    if (box.get(selectedList) == null) {
      db.createInitialData();
    } else {
      db.loadLists();
      db.loadData();
    }
    _sortToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedList == 'All Tasks' ? 'Listify' : selectedList,
          style: GoogleFonts.pacifico(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: const Text(
                  'Your Lists',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 3),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: db.allListNames.length,
                  itemBuilder: (context, index) {
                    return db.allListNames[index] != 'All Tasks'
                        ? ListNameTile(
                            listName: db.allListNames[index],
                            onDelete: () => _deleteList(index),
                            onEdit: () => _inputOrEditListName(index: index),
                            onSelected: () =>
                                setSelectedList(db.allListNames[index]))
                        : Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setSelectedList('All Tasks');
                                },
                                child: const Card.filled(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  margin: EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        top: 16,
                                        bottom: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'All Tasks',
                                            maxLines: null,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.extended(
                  onPressed: _inputOrEditListName,
                  label: const Text('New List'),
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
          ),
          child: SlidableAutoCloseBehavior(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  value: db.toDoList[index]['completed'],
                  task: db.toDoList[index]['task'],
                  star: db.toDoList[index]['starred'],
                  dueDate: db.toDoList[index]['dueDate'],
                  maxLines: db.toDoList[index]['maxLines'],
                  listName: selectedList == db.toDoList[index]['listName']
                      ? null
                      : db.toDoList[index]['listName'],
                  onChanged: (value) => _toggleTask(index, value),
                  onStarred: (star) => _toggleStar(index, star),
                  onDelete: () => _deleteTask(index),
                  onTaskTap: (maxLines) => _toggleMaxLines(index, maxLines),
                  onTaskLongPress: () => _showTaskInputEditField(index: index),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTaskInputEditField,
        child: const Icon(Icons.add),
      ),
    );
  }
}
