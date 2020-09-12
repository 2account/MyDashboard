import 'package:dashboard/repositories/todo/todorepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                      return TodoWidget(key: Key("${todo.id}"), todo: todo);
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
                      return TodoWidget(
                        key: Key("${todo.id}"),
                        todo: todo,
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
          onPressed: () async {
            HapticFeedback.vibrate();
          },
        ),
      ),
    );
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
