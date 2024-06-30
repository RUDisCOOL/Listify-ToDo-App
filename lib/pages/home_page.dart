import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/util/to_do_tile.dart';
import 'package:to_do_app/util/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box box = Hive.box('myTasks');
  Database db = Database();

  @override
  void initState() {
    if (box.get('ToDoList')==null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void _sortToDoList() {
    List<Map<String, dynamic>> completedTasks = [];
    List<Map<String, dynamic>> uncompletedTasks = [];

    for (var task in db.toDoList) {
      if (task['completed'] == true) {
        completedTasks.add(task);
      } else {
        uncompletedTasks.add(task);
      }
    }
    db.toDoList = uncompletedTasks + completedTasks;
  }

  final textController = TextEditingController();

  void _toggleTask(int index, bool? value) {
    setState(() {
      db.toDoList[index]['completed'] = value!;
      _sortToDoList();
      db.updateData();
    });
  }

  void _addTask(String task) {
    setState(() {
      db.toDoList.add({'task': task, 'completed': false});
      _sortToDoList();
      db.updateData();
    });
    textController.clear();
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
        surfaceTintColor: Colors.amber[50],
        scrolledUnderElevation: 50,
        foregroundColor: Colors.amber[50],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            value: db.toDoList[index]['completed'],
            task: db.toDoList[index]['task'],
            onChanged: (value) => _toggleTask(index, value),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            isScrollControlled: true,
            context: context,
            elevation: 5,
            backgroundColor: const Color.fromARGB(255, 30, 30, 30),
            builder: (context) {
              return Container(
                padding: EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 30,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: textController,
                      autocorrect: true,
                      autofocus: true,
                      style: TextStyle(color: Colors.amber[50]),
                      decoration: InputDecoration(
                        hintText: 'Enter a new task',
                        hintStyle: TextStyle(color: Colors.amber[50]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (textController.text.isNotEmpty) {
                              _addTask(textController.text);
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
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
