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
      // Key
      key: key,
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
                ? Text("Er du sikker på du er færdig med opgaven?")
                : Text("Er du sikker på du ikke er færdig med opgaven?")),
            // Actions
            actions: [
              FlatButton(
                child: Text(
                  "Ja",
                ),
                onPressed: () {
                  // Close Window
                  Navigator.pop(context, false);
                  // Change isComplete
                  setState(() {
                    todo.isComplete = ((newValue == true) ? "true" : "false");
                  });
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
            backgroundColor: Theme.of(context).backgroundColor,
          ),
        );
      },
      // Checkbox Placement
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}