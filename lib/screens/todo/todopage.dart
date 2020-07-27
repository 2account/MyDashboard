import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dashboard/models/todo/todomodel.dart';
import 'package:dashboard/widgets/todo/todowidget.dart';

class TodoPage extends StatefulWidget {
  TodoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<TodoModel> todoList = [
    TodoModel(1, 'First Item', 'First Description', false),
    TodoModel(2, 'Second Item', 'Second Description', false),
    TodoModel(3, 'Third Item', 'Third Description', false),
    TodoModel(4, 'Fourth Item', 'Fourth Description', false)
  ];

  List<TodoModel> completeList = [
    TodoModel(1, 'First Item', 'First Description', true),
    TodoModel(2, 'Second Item', 'Second Description', true),
    TodoModel(3, 'Third Item', 'Third Description', true),
    TodoModel(4, 'Fourth Item', 'Fourth Description', true)
  ];

  @override
  Widget build(BuildContext context) {
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
                      return TodoWidget(
                        key: Key("${todo.id}"),
                        todo: todo,
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
                  children: completeList.map(
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
          onPressed: () => {
            HapticFeedback.vibrate(),
          },
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final TodoModel item = todoList.removeAt(oldIndex);
      todoList.insert(newIndex, item);
    });
  }

  Widget buildBody() {
    return ReorderableListView(
      children: todoList.map((todo) {
        return TodoWidget(
          todo: todo,
        );
      }).toList(),
      onReorder: _onReorder,
    );
  }
}
