import 'dart:async';
import 'package:dashboard/widgets/notes/transparentroute.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dashboard/models/notes/note.dart';
import 'package:dashboard/repositories/notesrepository.dart';
import 'package:dashboard/widgets/notes/notesdetail.dart';
import 'package:sqflite/sqflite.dart';

class NotesPage extends StatefulWidget {
  // NotesPage Constructor
  NotesPage({Key key, @required this.title}) : super(key: key);

  // Used for storing the page title
  final title;

  // Create the page state
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // _NotesPageState Constructor
  _NotesPageState() : super() {
    // Log when the _HomePageState is being created
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Declare variables
  NotesRepository notesRepository = NotesRepository();
  List<Note> noteList;
  int _count = 0;

  // Build the _NotesPageState Widget
  @override
  Widget build(BuildContext context) {
    // Update the ListView if the noteList is empty
    if (noteList == null) {
      noteList = List<Note>();
      _updateListView();
    }

    // Return the Widget
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        child: getNoteListView(),
        color: Theme.of(context).backgroundColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          HapticFeedback.vibrate();
          navigateToDetail(Note('', '', '', ''), false);
        },
        tooltip: 'Tilføj en note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: _count,
      itemBuilder: (BuildContext context, int position) {
        return Dismissible(
          key: UniqueKey(),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              /// edit item
              return false;
            } else {
              bool willDelete;

              await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                    "Slet Note",
                  ),
                  content: Text(
                    "Er du sikker på du vil slette denne note?",
                  ),
                  actions: [
                    FlatButton(
                      child: Text(
                        "Ja",
                      ),
                      onPressed: () => {
                        Navigator.pop(context, false),
                        _delete(context, noteList[position]),
                        willDelete = true,
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Nej",
                      ),
                      onPressed: () => {
                        Navigator.pop(context, false),
                        willDelete = false,
                      },
                    ),
                  ],
                  backgroundColor: Theme.of(context).backgroundColor,
                ),
                barrierDismissible: false,
              );

              return willDelete;
            }
          },
          child: Card(
            color: Colors.white,
            child: ListTile(
              title: Text(
                this.noteList[position].title,
                style: TextStyle(color: Colors.grey[800]),
              ),
              subtitle: Text("${this.noteList[position].created}",
                  style: TextStyle(color: Colors.grey[750])),
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.grey[750],
                ),
                onTap: () {
                  _dialog(context, position);
                },
              ),
              onTap: () {
                navigateToDetail(this.noteList[position], true);
              },
            ),
          ),
        );
      },
    );
  }

  void _dialog(BuildContext context, int position) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Slet Note",
        ),
        content: Text(
          "Er du sikker på du vil slette denne note?",
        ),
        actions: [
          FlatButton(
            child: Text(
              "Ja",
            ),
            onPressed: () => {
              Navigator.pop(context, false),
              _delete(context, noteList[position]),
              _showSnackBar(context, "Noten blev slettet")
            },
          ),
          FlatButton(
            child: Text(
              "Nej",
            ),
            onPressed: () => Navigator.pop(context, false),
          )
        ],
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      barrierDismissible: false,
    );
  }

  void _delete(BuildContext context, Note note) async {
    int result = await notesRepository.deleteNoteAsync(note);
    if (result != 0) {
      _updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, bool isReadOnly) async {
     bool result = await Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) {
          return NoteDetail(
            note: note,
            isReadOnly: isReadOnly,
          );
        },
      ),
    );

    if (result == true) {
      _updateListView();
    }
  }

  Future<void> _updateListView() async {
    final Future<Database> dbFuture = notesRepository.initializeDatabaseAsync();
    dbFuture.then(
      (database) {
        Future<List<Note>> noteListFuture = notesRepository.getNoteListAsync();
        noteListFuture.then(
          (noteList) {
            setState(
              () {
                this.noteList = noteList;
                this._count = noteList.length;
              },
            );
          },
        );
      },
    );
  }
}
