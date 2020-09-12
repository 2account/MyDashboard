import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:dashboard/models/todo/todomodel.dart';
import 'package:dashboard/repositories/base/repositorybase.dart';

class TodoRepository  extends RepositoryBase {

  /* Fields
  -------------------------------------------------- */

  /// Static object for singleton repository 
  static TodoRepository _todoRepository;

  /* Table & Column names
  -------------------------------------------------- */

  // Table name
  String _todoTable = "todos";
  // Column names
  String _colId = "id";
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
  Future<int> deleteAsync(TodoModel todo) async {

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