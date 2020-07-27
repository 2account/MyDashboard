import 'package:flutter/material.dart';
import 'package:dashboard/models/notes/note.dart';
import 'package:dashboard/repositories/notesrepository.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  // Constructor
  NoteDetail({Key key, @required this.note, @required this.isReadOnly})
      : super(key: key);
  // Used for storing the note being edited
  final Note note;
  // Used for the textfields,
  final bool isReadOnly;
  // Create the page state
  @override
  _NoteDetailState createState() => _NoteDetailState(note, isReadOnly);
}

class _NoteDetailState extends State<NoteDetail> {
  // _NoteDetailState Constructor
  _NoteDetailState(this.note, this.isReadOnly) : super();

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

  // key
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Notes Repository
  NotesRepository notesRepository = NotesRepository();
  // Bool for the Title header
  bool isReadOnly;
  // Bool for checking if anything changed
  bool hasContentChanged;
  // The note itself
  Note note;

  // Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  // Build function
  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    contentController.text = note.content;

    return Dismissible(
      confirmDismiss: (direction) async {
        if (hasContentChanged == true) {
          bool willDelete;

          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(
                "Note Ikke gemt",
              ),
              content: Text(
                "Er du sikker på du vil lukke noten uden at gemme?",
              ),
              actions: [
                FlatButton(
                  child: Text(
                    "Ja",
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                    willDelete = true;
                  },
                ),
                FlatButton(
                  child: Text(
                    "Nej",
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                    willDelete = false;
                  },
                ),
              ],
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            barrierDismissible: false,
          );
          if (willDelete == true) {
            Navigator.pop(context, true);
          }
          return willDelete;
        } else {
          Navigator.pop(context, true);
          return true;
        }
      },
      background: null,
      direction: DismissDirection.down,
      key: UniqueKey(),
      child: WillPopScope(
        onWillPop: () async {
          if (isReadOnly == false && hasContentChanged == true) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(
                  "Note ikke gemt",
                ),
                content: Text(
                  "Er du sikker på du vil gå tilbage uden af gemme?",
                ),
                actions: [
                  FlatButton(
                    child: Text(
                      "Ja",
                    ),
                    onPressed: () => {
                      Navigator.pop(context, false),
                      _moveToLastScreen(),
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Nej",
                    ),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
                backgroundColor: Theme.of(context).backgroundColor,
              ),
              barrierDismissible: false,
            );
          } else {
            _moveToLastScreen();
          }
          return false;
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).backgroundColor,
          // AppBar
          appBar: AppBar(
            // Leading icon
            leading: IconButton(
              icon: Icon(((isReadOnly == true) ? Icons.arrow_back : null)),
              splashColor: ((isReadOnly == true)
                  ? Theme.of(context).primaryColor
                  : Colors.transparent),
              highlightColor: ((isReadOnly == false)
                  ? Theme.of(context).primaryColor
                  : Colors.transparent),
              onPressed: () {
                setState(
                  () {
                    if (isReadOnly == true) {
                      _moveToLastScreen();
                    }
                  },
                );
              },
            ),
            // Background Color
            backgroundColor: Theme.of(context).primaryColor,
            // Title TextField
            title: Container(
              margin: EdgeInsets.only(right: 7),
              height: 45,
              padding: EdgeInsets.only(
                left: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
                border: Border.all(
                  color: ((isReadOnly == false)
                      ? Colors.black12
                      : Colors.transparent),
                ),
              ),
              child: TextField(
                style: TextStyle(fontSize: 22.5, color: Colors.white),
                readOnly: isReadOnly,
                maxLength: 32,
                controller: titleController,
                onChanged: (value) {
                  hasContentChanged = true;
                  _updateTitle();
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 5),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: ((isReadOnly == false) ? "Indtast Titel" : ""),
                  counterText: "",
                ),
              ),
            ),
            // Actions Bar
            actions: [
              IconButton(
                padding: EdgeInsets.only(right: 15),
                icon: Icon(((isReadOnly == true) ? Icons.edit : Icons.check)),
                splashColor: ((isReadOnly == true)
                    ? Theme.of(context).primaryColor
                    : Colors.transparent),
                highlightColor: ((isReadOnly == true)
                    ? Theme.of(context).primaryColor
                    : Colors.transparent),
                onPressed: () {
                  setState(
                    () {
                      if (isReadOnly == true) {
                        isReadOnly = false;
                      } else if (hasContentChanged == true) {
                        // Save the note
                        _save();
                      } else {
                        isReadOnly = true;
                      }
                    },
                  );
                },
              ),
            ],
          ),
          // Body
          body: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onDoubleTap: () {
                    setState(
                      () => {
                        isReadOnly = false,
                      },
                    );
                  },
                  child: TextField(
                    key: UniqueKey(),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: ((isReadOnly == false) ? "Skriv din note" : ""),
                      contentPadding: EdgeInsets.only(
                        left: 7,
                        top: 5,
                        bottom: 1,
                      ),
                    ),
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    readOnly: isReadOnly,
                    keyboardType: TextInputType.multiline,
                    // maxLines: null,
                    controller: contentController,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.grey[850]),
                    onChanged: (value) {
                      hasContentChanged = true;
                      _updateContent();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of Note object
  void _updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of Note object
  void _updateContent() {
    note.content = contentController.text;
  }

  // Save data to database
  void _save() async {
    // Set the page to read only
    isReadOnly = true;

    // If content has been changed
    if (hasContentChanged == true) {
      // If the note has just been created
      if (note.id != null) {
        // Set the property to now
        note.edited = DateFormat.yMMMd().format(DateTime.now());
      }
      //
      else {
        // Set the property to now
        note.created = DateFormat.yMMMd().format(DateTime.now());
      }

      // For saving the database result
      int result;

      // If the note exists, update it
      if (note.id != null) {
        // Run the update operation
        result = await notesRepository.updateNoteAsync(note);
      }
      // If the note does not exist, insert it
      else {
        // Run the insert operation
        result = await notesRepository.insertNoteAsync(note);
        // Get the id of the insert, and set it to prevent error later
        note.id = await notesRepository.getLastInsertedId();
      }

      // Set content changed to false, since it just got saved
      hasContentChanged = false;

      // If the operation succeeded
      if (result != 0) {
        // If edited is not null, meaning it has already been saved
        if (note.edited != null) {
          // Show changes was saved
          _showSnackBar("Dine ændringer blev gemt.");
        }
        // If the note has just been created
        else {
          // Show the note was saved
          _showSnackBar("Din note blev gemt.");
        }
      }
      // If the operation somehow failed
      else {
        // Show failure to user
        _showSnackBar("Der opstod en fejl under forsøget på at gemme.");
      }
    }
    // If nothing was changed in the content
    else {
      _showSnackBar("Ingen ændringer lavet. Intet blev gemt.");
    }
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
