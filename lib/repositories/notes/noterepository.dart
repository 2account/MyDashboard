import 'dart:async';
import 'package:dashboard/models/notes/notemodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dashboard/repositories/base/repositorybase.dart';

/// Repository class used for accessing the SQLite database
class NoteRepository extends RepositoryBase {

  /* Fields
  -------------------------------------------------- */

  /// Static object for singleton repository 
  static NoteRepository _noteRepository;

  /* Table & Column names
  -------------------------------------------------- */

  String _noteTable = 'note_table';
  String _colId = 'id';
  String _colCreated = 'created';

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

  /* Map Functions
  -------------------------------------------------- */

  Future<List<Map<String, dynamic>>> _getMapListAsync() async {

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
  Future<int> insertAsync(NoteModel note) async {

    // Get the database instance
    Database database = await this.database;

    // Run the Insert query
    int result = await database.insert(_noteTable, note.toMap());

    // Return the result
    return result;
  }

  // Read
  /// Returns all notes from the database
  Future<List<NoteModel>> getAllAsync() async {

    // Get the Map List from the database
    List<Map<String, dynamic>> noteMapList = await _getMapListAsync();

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
  Future<int> updateAsync(NoteModel note) async {

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
  Future<int> deleteAsync(NoteModel note) async {

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