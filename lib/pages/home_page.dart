import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/util/to_do_tile.dart';
import 'package:to_do_app/util/database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

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
  final _inputHintColor = const Color.fromARGB(255, 85, 85, 70);

  Box box = Hive.box('myTasks');
  Database db = Database();
  final textController = TextEditingController();
  DateTime? dueDate;
  DateTime? pickedDate;

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
      db.toDoList[index]['completed'] = value!;
      _sortToDoList();
      db.updateData();
    });
  }

  void _toggleStar(int index, bool? star) {
    setState(() {
      db.toDoList[index]['starred'] = star!;
      _sortToDoList();
      db.updateData();
    });
  }

  void _addTask(String task, bool starred, DateTime? dueDate) {
    setState(() {
      db.toDoList.add({
        'task': task,
        'completed': false,
        'starred': starred,
        'dueDate': dueDate,
      });
      _sortToDoList();
      db.updateData();
    });
    textController.clear();
  }

  void _deleteTask(index) {
    setState(() {
      db.toDoList.removeAt(index);
      _sortToDoList();
      db.updateData();
    });
  }

  @override
  void initState() {
    if (box.get('ToDoList') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Listify',
          style: GoogleFonts.pacifico(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
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
                onChanged: (value) => _toggleTask(index, value),
                onStarred: (star) => _toggleStar(index, star),
                onDelete: () => _deleteTask(index),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bool starred = false;
          dueDate = null;

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
                        autocorrect: true,
                        autofocus: true,
                        style: TextStyle(color: _textInputColor),
                        decoration: const InputDecoration(
                          hintText: 'Enter a new task',
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (dueDate != null)
                            Text(
                              "Due: ${dueDate!.day} ${DateFormat.MMM().format(dueDate!)}, ${dueDate!.year}",
                              style: TextStyle(
                                color: _textInputColor,
                                fontSize: 16,
                                backgroundColor: Color.fromARGB(0, 0, 0, 0),
                              ),
                            ),
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
                            onPressed: () async {
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
                            },
                            icon: Icon(
                              (dueDate == null)
                                  ? Icons.calendar_today_outlined
                                  : Icons.calendar_today_rounded,
                              color: _calendarIconColor,
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(_textInputColor),
                              foregroundColor:
                                  WidgetStatePropertyAll(_inputHintColor),
                            ),
                            onPressed: () {
                              if (textController.text.isNotEmpty) {
                                _addTask(textController.text, starred, dueDate);
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
