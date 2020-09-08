import 'dart:async';
import 'dart:io';
import 'package:dashboard/models/notes/notemodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Repository class used for accessing the SQLite database
class NoteRepository {

  /* Fields
  -------------------------------------------------- */

  /// Static object for singleton repository 
  static NoteRepository _noteRepository;
  /// Static object Singleton database
  static Database _database;

  /* Table & Column names
  -------------------------------------------------- */

  String _noteTable = 'note_table';
  String _colId = 'id';
  String _colTitle = 'title';
  String _colContent = 'content';
  String _colCategory = 'category';
  String _colCreated = 'created';
  String _colEdited = 'edited';

  /* Constructors
  -------------------------------------------------- */

  // Named constructor for initializing an instance of Repository
  NoteRepository._createInstance();

  /// Returns the repository instance if it exists,
  /// otherwise it initializes, and retuns it.
  factory NoteRepository() {
    
    // Only initialize the repository instance
    // if it is not already initialized
    if (_noteRepository == null) {
      _noteRepository = NoteRepository._createInstance();
    }

    // Return the _repository instance
    return _noteRepository;
  }

  /* Getters
  -------------------------------------------------- */

  // Getter for getting the database
  Future<Database> get database async {

    // If database is null, initialize it
    if (_database == null) {
      _database = await initializeDatabaseAsync();
    }

    // Return the database instance
    return _database;
  }

  /* Database functions 
  -------------------------------------------------- */

  // Function for initializing the database
  Future<Database> initializeDatabaseAsync() async {
    
    // Get the directory path for both Android and iOS to store the database
    Directory directory = await getApplicationDocumentsDirectory();

    // Define the database path
    String path = "${directory.path}notes.db";

    // Open/Create the database at the given path
    Database notes =
        await openDatabase(path, version: 1, onCreate: _createDbAsync);

    // Return the created database
    return notes;
  }

  // Function for creating the database
  void _createDbAsync(Database database, int newVersion) async {

    // Create the new database
    await database.execute(
        'CREATE TABLE $_noteTable($_colId INTEGER PRIMARY KEY AUTOINCREMENT, $_colTitle TEXT, $_colContent TEXT, $_colCategory TEXT, $_colCreated TEXT, $_colEdited TEXT)');
  }

  /* Map Functions
  -------------------------------------------------- */

  Future<List<Map<String, dynamic>>> _getNoteMapListAsync() async {

    // Get the database instance
    Database database = await this.database;

    // Run the Select query
    List<Map<String, dynamic>> result =
        await database.query(_noteTable, orderBy: '$_colCreated ASC');

    // Return the result
    return result;
  }

  /* Crud Functions
  -------------------------------------------------- */

  // Create
  /// Inserts a note into the database
  Future<int> insertNoteAsync(NoteModel note) async {

    // Get the database instance
    Database database = await this.database;

    // Run the Insert query
    int result = await database.insert(_noteTable, note.toMap());

    // Return the result
    return result;
  }

  // Read
  /// Returns all notes from the database
  Future<List<NoteModel>> getAllNotesAsync() async {

    // Get the Map List from the database
    List<Map<String, dynamic>> noteMapList = await _getNoteMapListAsync();

    // Count the number of map entries in db table
    int count = noteMapList.length;

    // Create a note list for storing the results from the Map List
    List<NoteModel> noteList = List<NoteModel>();

    // For loop to create a Note List from thhe Map List
    for (int i = 0; i < count; i++) {
      noteList.add(NoteModel.fromMap(noteMapList[i]));
    }
    
    // Return the Note List
    return noteList;
  }

  // Update
  /// Updates an existing note in the database
  Future<int> updateNoteAsync(NoteModel note) async {

    // Get the database instance
    Database database = await this.database;

    // Run the Update query
    int result = await database.update(_noteTable, note.toMap(),
        where: '$_colId = ?', whereArgs: [note.id]);

    // Return the result
    return result;
  }

  // Delete
  /// Deletes a note in the database
  Future<int> deleteNoteAsync(NoteModel note) async {

    // Get the database instance
    Database database = await this.database;

    // Run the Delete query
    int result = await database
        .delete(_noteTable, where: '$_colId = ?', whereArgs: [note.id]);

    // Return the result
    return result;
  }

  /* Other Functions
  -------------------------------------------------- */

  // Get last id
  /// Returns the id of last item inserted into the database
  Future<int> getLastInsertedIdAsync() async {

    // Get the database instance
    Database database = await this.database;

    // Run the Select query
    List<Map<String, dynamic>> resultId = await database.rawQuery("SELECT last_insert_rowid()");

    // Convert the resultCount to an int
    int result = Sqflite.firstIntValue(resultId);

    // Return the result
    return result;
  }

  // Total
  /// Returns the total count of items in the database
  Future<int> getCountAsync() async {

    // Get the database instance
    Database database = await this.database;

    // Run the Select query
    List<Map<String, dynamic>> resultCount =
        await database.rawQuery('SELECT COUNT (*) FROM $_noteTable');

    // Convert the resultCount to an int
    int result = Sqflite.firstIntValue(resultCount);

    // Return the result
    return result;
  }
}