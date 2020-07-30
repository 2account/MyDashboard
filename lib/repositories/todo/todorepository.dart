import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dashboard/models/notes/notemodel.dart';

class TodoRepository {
  /// Singleton repository object
  static TodoRepository _todoRepository;
  /// Singleton database object
  static Database _database;


  /*
      Table & Column Names
  */

  // Table name
  String _todoTable = "todo_table";
  // Column names
  String _colId = "id";
  String _colTitle = "title";
  String _colDescription = "description";
  String _colIsComplete = "isComplete";


  /*
      Constructors
  */

  // Named constructor for creating an instance of Repository
  TodoRepository._createInstance();

  // Factory constructor for,
  // returning an existing instance of Repository
  factory TodoRepository() {
    // Only create an instance of Repository
    // if it doesn't already exist
    if (_todoRepository == null) {
      _todoRepository = TodoRepository._createInstance();
    }
    // Return the _repository instance
    return _todoRepository;
  }


  /*
      Database Functions
  */

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
    String path = "${directory.path}todos.db";
    // Open/Create the database at the given path
    Database todos =
        await openDatabase(path, version: 1, onCreate: _createDbAsync);
    // Return the created database
    return todos;
  }

  // Function for creating the database
  void _createDbAsync(Database database, int newVersion) async {
    // Create the new database
    await database.execute(
        'CREATE TABLE $_todoTable($_colId INTEGER PRIMARY KEY AUTOINCREMENT, $_colTitle TEXT, $_colDescription TEXT, $_colIsComplete BOOLEAN)');
  }


  /*
      CRUD Functions
  */
}