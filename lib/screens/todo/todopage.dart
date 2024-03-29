import 'package:dashboard/repositories/todo/todorepository.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/models/todo/todomodel.dart';
import 'package:dashboard/widgets/todo/todowidget.dart';
import 'package:sqflite/sqflite.dart';

class TodoPage extends StatefulWidget {
  TodoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  /// Object for accessing the database
  TodoRepository repo = new TodoRepository();

  /// List of tasks not yet completed
  List<TodoModel> todoList;

  /// List of tasks that have been completed
  List<TodoModel> doneList;

  @override
  Widget build(BuildContext context) {
    // Initialize the lists if they are null
    if (todoList == null && doneList == null) {
      // Initialize lists
      todoList = List<TodoModel>();
      doneList = List<TodoModel>();

      // Load the todo items from the database
      _loadTodoItems();
    }

    // Return widget element
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.format_list_numbered_rtl),
              ),
              Tab(
                icon: Icon(Icons.playlist_add_check),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Center(
                child: ReorderableListView(
                  onReorder: _onReorderUncomplete,
                  children: todoList.map(
                    (todo) {
                      return TodoWidget(
                        key: Key("${todo.id}"),
                        todo: todo,
                        onPressed: () async {
                          // Close dialog
                          Navigator.pop(context, false);

                          // Check if isComplete is true
                          if (todo.isComplete == "true") {
                            // Update item in the database
                            int result = await repo.updateAsync(todo);

                            // Check result
                            if (result != 0) {
                              // Update the lists
                              setState(() {
                                todoList.remove(todo);

                                doneList.add(todo);
                              });
                            }
                          }
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            Container(
              child: Center(
                child: ReorderableListView(
                  onReorder: _onReordercomplete,
                  children: doneList.map(
                    (todo) {
                      return TodoWidget(
                        key: Key("${todo.id}"),
                        todo: todo,
                        onPressed: () async {
                          // Close dialog
                          Navigator.pop(context, false);

                          // Check if isComplete is true
                          if (todo.isComplete == "false") {
                            // Update item in the database
                            int result = await repo.updateAsync(todo);

                            // Check result
                            if (result != 0) {
                              // Update the lists
                              setState(() {
                                doneList.remove(todo);

                                todoList.add(todo);
                              });
                            }
                          }
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: () => _showAddItemDialog(context),
        ),
      ),
    );
  }

  /// Shows the dialog for adding a task
  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          actions: [
            FlatButton(
              child: Text("Tilføj"),
              onPressed: () => _addItem(),
            )
          ],
          content: Container(
            height: 120,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Titel",
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Beskrivelse",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Adds a task to the database
  void _addItem() async {
    // Create new task object with the textfield values
    TodoModel newModel = new TodoModel(
        titleController.text, descriptionController.text, "false");

    titleController.text = "";
    descriptionController.text = "";

    // Insert the new task into the database
    int result = await repo.insertAsync(newModel);

    // Check if the insertion was successful
    if (result != 0) {
      // Pop the dialog box
      Navigator.of(context).pop();

      // Get the id of the inserted task
      newModel.id = await repo.getLastInsertedIdAsync();

      // Tell the framework something has changed
      setState(() {
        // Add the new model to the todolist
        todoList.add(newModel);
      });
    }
  }

// TODO: Find a way to avoid duplicate reorder functions
  void _onReorderUncomplete(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      TodoModel todo = todoList[oldIndex];

      todoList.removeAt(oldIndex);
      todoList.insert(newIndex, todo);
    });

    // This is so shit & resource heavy
    todoList.asMap().forEach((index, task) {
      // Set task.id to the index
      task.id = index + 1;
    });

    todoList.forEach((task) {
      debugPrint(
          "ID: ${task.id} Title: ${task.title} Description: ${task.description} isComplete: ${task.isComplete}");
    });

    todoList.forEach((task) async {
      // Int for checking result
      int result;

      // Update task
      result = await repo.updateAsync(task);

      // Check result
      if (result != 0) {
        // Print values
        debugPrint(
            "ID: ${task.id} Title: ${task.title} Description: ${task.description} isComplete: ${task.isComplete}");
      }
    });
  }

  void _onReordercomplete(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      TodoModel todo = doneList[oldIndex];

      doneList.removeAt(oldIndex);
      doneList.insert(newIndex, todo);
    });

    // This is so shit & resource heavy
    doneList.asMap().forEach((index, task) {
      // Set task.id to the index
      task.id = index + 1;
    });

    doneList.forEach((task) {
      debugPrint(
          "ID: ${task.id} Title: ${task.title} Description: ${task.description} isComplete: ${task.isComplete}");
    });

    doneList.forEach((task) async {
      // Int for checking result
      int result;

      // Update task
      result = await repo.updateAsync(task);

      // Check result
      if (result != 0) {
        // Print values
        debugPrint(
            "ID: ${task.id} Title: ${task.title} Description: ${task.description} isComplete: ${task.isComplete}");
      }
    });
  }

  /// Loads the todo items from the database
  Future<void> _loadTodoItems() async {
    // Initialize the database
    final Future<Database> dbFuture = repo.initializeDatabaseAsync();

    // When the database has been initialized
    dbFuture.then(
      // Database parameter
      (database) {
        // Get all items
        Future<List<TodoModel>> noteListFuture = repo.getAllAsync();

        // When all items has been retrieved
        noteListFuture.then(
          // Result parameter
          (resultList) {
            // Notify state change
            setState(
              () {
                // Check each item
                resultList.forEach((item) {
                  // Add to doneList if complete
                  if (item.isComplete == "true") {
                    doneList.add(item);
                  }
                  // Add to todoList if uncomplete
                  else {
                    todoList.add(item);
                  }
                });
              },
            );
          },
        );
      },
    );
  }
}
