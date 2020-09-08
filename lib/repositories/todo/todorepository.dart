import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dashboard/models/todo/todomodel.dart';

class TodoRepository {

  /* Fields
  -------------------------------------------------- */

  /// Static object for singleton repository 
  static TodoRepository _todoRepository;
  /// Static object Singleton database
  static Database _database;

  /* Table & Column names
  -------------------------------------------------- */

  // Table name
  String _todoTable = "todo_table";
  // Column names
  String _colId = "id";
  String _colTitle = "title";
  String _colDescription = "description";
  String _colIsComplete = "isComplete";

  /* Constructors
  -------------------------------------------------- */

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

  /* Map Functions
  -------------------------------------------------- */

  Future<List<Map<String, dynamic>>> _getMapListAsync() async {

    // Get the database instance
    Database database = await this.database;

    // Run the Select query
    List<Map<String, dynamic>> result =
        await database.query(_todoTable, orderBy: '$_colIsComplete ASC');

    // Return the result
    return result;
  }

  /* Crud Functions
  -------------------------------------------------- */

  // Create
  /// Inserts a note into the database
  Future<int> insertAsync(TodoModel todo) async {

    // Get the database instance
    Database database = await this.database;

    // Run the Insert query
    int result = await database.insert(_todoTable, todo.toMap());

    // Return the result
    return result;
  }

  // Read
  /// Returns all items from the database
  Future<List<TodoModel>> getAllAsync() async {

    // Get the Map List from the database
    List<Map<String, dynamic>> mapList = await _getMapListAsync();

    // Count the number of map entries in db table
    int count = mapList.length;

    // Create a list for storing the results from the Map List
    List<TodoModel> itemList = List<TodoModel>();

    // For loop to iterate through, and save the items from the map
    for (int i = 0; i < count; i++) {
      itemList.add(TodoModel.fromMap(mapList[i]));
    }

    // Return the Note List
    return itemList;
  }

  // Update
  /// Updates an existing item in the database
  Future<int> updateAsync(TodoModel todo) async {

    // Get the database instance
    Database database = await this.database;

    // Run the Update query
    int result = await database.update(_todoTable, todo.toMap(),
        where: '$_colId = ?', whereArgs: [todo.id]);

    // Return the result
    return result;
  }

  // Delete
  /// Deletes an item in the database
  Future<int> deleteNoteAsync(TodoModel todo) async {

    // Get the database instance
    Database database = await this.database;

    // Run the Delete query
    int result = await database
        .delete(_todoTable, where: '$_colId = ?', whereArgs: [todo.id]);

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
        await database.rawQuery('SELECT COUNT (*) FROM $_todoTable');

    // Convert the resultCount to an int
    int result = Sqflite.firstIntValue(resultCount);
    
    // Return the result
    return result;
  }
}