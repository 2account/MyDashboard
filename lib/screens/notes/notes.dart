import 'dart:async';
import 'package:dashboard/widgets/notes/transparentroute.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dashboard/models/notes/notemodel.dart';
import 'package:dashboard/repositories/notes/noterepository.dart';
import 'package:dashboard/widgets/notes/notedetail.dart';
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
  NoteRepository noteRepository = NoteRepository();
  List<NoteModel> noteList;
  int _count = 0;

  // Build the _NotesPageState Widget
  @override
  Widget build(BuildContext context) {
    
    // Update the ListView if the noteList is empty
    if (noteList == null) {
      noteList = List<NoteModel>();
      _updateListView();
    }

    // Returns the widget scaffold
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
          navigateToDetail(NoteModel('', '', '', ''), false);
        },
        tooltip: 'Tilføj en note',
        child: Icon(Icons.add),
      ),
    );
  }

  /// Returns a listview containing all notes in the database
  ListView getNoteListView() {
    return ListView.builder(
      itemCount: _count,
      itemBuilder: (BuildContext context, int position) {
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.startToEnd,
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

  /// Shows confirmation dialog,
  /// for when a note is being deleted.
  void _dialog(BuildContext context, int position) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        // Title
        title: Text(
          "Slet Note",
        ),
        // Content
        content: Text(
          "Er du sikker på du vil slette denne note?",
        ),
        // Choices
        actions: [
          // Yes, will delete
          FlatButton(
            child: Text(
              "Ja",
            ),
            onPressed: () => {
              // Close dialog
              Navigator.pop(context, false),
              // Delete note
              _delete(context, noteList[position]),
              // Show deletion confirmation
              _showSnackBar(context, "Noten blev slettet")
            },
          ),
          // No, wont delete
          FlatButton(
            child: Text(
              "Nej",
            ),
            // Close dialog
            onPressed: () => Navigator.pop(context, false),
          )
        ],
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      // Dialog can't be dismissed.
      barrierDismissible: false,
    );
  }

  /// Deletes a specified note in the database
  void _delete(BuildContext context, NoteModel note) async {
    int result = await noteRepository.deleteNoteAsync(note);
    if (result != 0) {
      _updateListView();
    }
  }

  /// Shows the snackbar with the provided message
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  /// Navigates to a specified note
  void navigateToDetail(NoteModel note, bool isReadOnly) async {
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

  /// Updates the listview containing the notes
  Future<void> _updateListView() async {
    final Future<Database> dbFuture = noteRepository.initializeDatabaseAsync();
    dbFuture.then(
      (database) {
        Future<List<NoteModel>> noteListFuture =
            noteRepository.getAllNotesAsync();
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