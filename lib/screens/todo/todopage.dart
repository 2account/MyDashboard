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
                  onReorder: _onReorder,
                  children: todoList.map(
                    (todo) {
                      return CheckboxListTile(
                        // Key
                        key: Key("${todo.id}"),
                        // Checkbox Value
                        value: ((todo.isComplete == "true") ? true : false),
                        // Title
                        title: Text(
                          "${todo.title}",
                        ),
                        // Subtitle
                        subtitle: Text(
                          "${todo.description}",
                        ),
                        // OnChanged Event
                        onChanged: (bool newValue) {
                          // Show dialog window
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AlertDialog(
                              // Title
                              title: ((todo.isComplete == "false")
                                  ? Text("Færdiggør Opgave")
                                  : Text("Ufærdiggør Opgave")),
                              // Content
                              content: ((todo.isComplete == "false")
                                  ? Text(
                                      "Er du sikker på du er færdig med opgaven?")
                                  : Text(
                                      "Er du sikker på du ikke er færdig med opgaven?")),
                              // Actions
                              actions: [
                                FlatButton(
                                  child: Text(
                                    "Ja",
                                  ),
                                  onPressed: () async {
                                    // Close dialog
                                    Navigator.pop(context, false);

                                    // Change isComplete
                                    todo.isComplete =
                                        ((newValue == true) ? "true" : "false");

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
                                ),
                                FlatButton(
                                  child: Text(
                                    "Nej",
                                  ),
                                  onPressed: () => {
                                    Navigator.pop(context, false),
                                  },
                                ),
                              ],
                              // Background Color
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                            ),
                          );
                        },
                        // Checkbox Placement
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            Container(
              child: Center(
                child: ReorderableListView(
                  onReorder: _onReorder,
                  children: doneList.map(
                    (todo) {
                      return CheckboxListTile(
                        // Key
                        key: Key("${todo.id}"),
                        // Checkbox Value
                        value: ((todo.isComplete == "true") ? true : false),
                        // Title
                        title: Text(
                          "${todo.title}",
                        ),
                        // Subtitle
                        subtitle: Text(
                          "${todo.description}",
                        ),
                        // OnChanged Event
                        onChanged: (bool newValue) {
                          // Show dialog window
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AlertDialog(
                              // Title
                              title: ((todo.isComplete == "false")
                                  ? Text("Færdiggør Opgave")
                                  : Text("Ufærdiggør Opgave")),
                              // Content
                              content: ((todo.isComplete == "false")
                                  ? Text(
                                      "Er du sikker på du er færdig med opgaven?")
                                  : Text(
                                      "Er du sikker på du ikke er færdig med opgaven?")),
                              // Actions
                              actions: [
                                FlatButton(
                                  child: Text(
                                    "Ja",
                                  ),
                                  onPressed: () async {
                                    // Close dialog
                                    Navigator.pop(context, false);

                                    // Change isComplete
                                    todo.isComplete =
                                        ((newValue == true) ? "true" : "false");

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
                                ),
                                FlatButton(
                                  child: Text(
                                    "Nej",
                                  ),
                                  onPressed: () => {
                                    Navigator.pop(context, false),
                                  },
                                ),
                              ],
                              // Background Color
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                            ),
                          );
                        },
                        // Checkbox Placement
                        controlAffinity: ListTileControlAffinity.leading,
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

  /// Reorders items
  void _onReorder(int oldIndex, int newIndex) {
    // Notify state change
    setState(() {
      // Set new index value
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      // Remove old index item
      final TodoModel item = todoList.removeAt(oldIndex);
      // Insert item at new index
      todoList.insert(newIndex, item);
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
