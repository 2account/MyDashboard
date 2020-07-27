import 'package:flutter/material.dart';
import 'package:dashboard/models/todo/todomodel.dart';

class TodoWidget extends StatefulWidget {
  // Constructor
  TodoWidget({Key key, this.todo}) : super(key: key);

  // Field
  final TodoModel todo;

  // Override
  @override
  _TodoWidgetState createState() => _TodoWidgetState(todo, key);
}

class _TodoWidgetState extends State<TodoWidget> {
  // Constructor
  _TodoWidgetState(this.todo, this.key) : super();

  // Fields
  TodoModel todo;
  Key key;

  // Widget builder
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      key: key,
      value: todo.isComplete,
      title: Text(
        "${todo.title}",
      ),
      subtitle: Text(
        "${todo.description}",
      ),
      onChanged: (bool newValue) {
        setState(() {
          todo.isComplete = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
