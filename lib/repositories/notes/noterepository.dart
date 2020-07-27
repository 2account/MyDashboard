import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dashboard/models/notes/notemodel.dart';

/// Repository class used for accessing the SQLite database
class NoteRepository {
  static NoteRepository _noteRepository; // Singleton Repository
  static Database _database; // Singleton Database

  // Table, and column names
  String _noteTable = 'note_table';
  String _colId = 'id';
  String _colTitle = 'title';
  String _colContent = 'content';
  String _colCategory = 'category';
  String _colCreated = 'created';
  String _colEdited = 'edited';

  // Named constructor for creating an instance of Repository
  NoteRepository._createInstance();

  // Factory constructor for,
  // returning an existing instance of Repository
  factory NoteRepository() {
    // Only create an instance of Repository
    // if it doesn't already exist
    if (_noteRepository == null) {
      _noteRepository = NoteRepository._createInstance();
    }
    // Return the _repository instance
    return _noteRepository;
  }

  // Getter for getting the database
  Future<Database> get database async {
    // If database is null, initialize it
    if (_database == null) {
      _database = await initializeDatabaseAsync();
    }
    // Return the database instance
    return _database;
  }

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

  // Create
  Future<int> insertNoteAsync(NoteModel note) async {
    // Get the database instance
    Database database = await this.database;
    // Run the Insert query
    int result = await database.insert(_noteTable, note.toMap());
    // Return the result
    return result;
  }

  // Read
  Future<List<Map<String, dynamic>>> _getNoteMapListAsync() async {
    // Get the database instance
    Database database = await this.database;
    // Run the Select query
    List<Map<String, dynamic>> result =
        await database.query(_noteTable, orderBy: '$_colCreated ASC');
    // Return the result
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<NoteModel>> getNoteListAsync() async {
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

  // Get last id
  Future<int> getLastInsertedId() async {
    // Get the database instance
    Database database = await this.database;
    // Run the Select query
    List<Map<String, dynamic>> resultId = await database.rawQuery("SELECT last_insert_rowid()");
    // Convert the resultCount to an int
    int result = Sqflite.firstIntValue(resultId);
    // Return the result
    return result;
  }

  // Update
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
  Future<int> deleteNoteAsync(NoteModel note) async {
    // Get the database instance
    Database database = await this.database;
    // Run the Delete query
    int result = await database
        .delete(_noteTable, where: '$_colId = ?', whereArgs: [note.id]);
    // Return the result
    return result;
  }

  // Total
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
