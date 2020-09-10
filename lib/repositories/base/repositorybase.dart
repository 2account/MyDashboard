import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RepositoryBase {

  /* Fields
  -------------------------------------------------- */

  /// Static object Singleton database
  static Database _database;

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
    String path = "${directory.path}mydashboard.db";

    // Open/Create the database at the given path
    Database mydashboard =
        await openDatabase(path, version: 1, onCreate: _createDbAsync);

    // Return the created database
    return mydashboard;
  }

  // Function for creating the database
  void _createDbAsync(Database database, int newVersion) async {


    // Notes
    String _noteTable = 'note_table';
    String _colId = 'id';
    String _colTitle = 'title';
    String _colContent = 'content';
    String _colCategory = 'category';
    String _colCreated = 'created';
    String _colEdited = 'edited';

    // Todo 
    String _todoTable = "todo_table";
    String _colDescription = "description";
    String _colIsComplete = "isComplete";


    // Create the new database
    await database.execute(
        'CREATE TABLE $_noteTable($_colId INTEGER PRIMARY KEY AUTOINCREMENT, $_colTitle TEXT, $_colContent TEXT, $_colCategory TEXT, $_colCreated TEXT, $_colEdited TEXT);' +
        'CREATE TABLE $_todoTable($_colId INTEGER PRIMARY KEY AUTOINCREMENT, $_colTitle TEXT, $_colDescription TEXT, $_colIsComplete BOOLEAN)');
  }

  /* Other Functions
  -------------------------------------------------- */

  // Get id of last inserted item
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
}