import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TodoPage extends StatefulWidget {
  TodoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
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
          children: <Widget>[
            Container(
              child: Center(
                child: Text("Uncomplete Tasks"),
              ),
            ),
            Container(
              child: Center(
                child: Text("Completed Tasks"),
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
}
