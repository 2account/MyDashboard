/// Model used for storing todo task data in the dashboard todo section
class TodoModel {
  /*
      Fields
  */

  /// The database id
  int _id;
  /// Title of the task
  String _title;
  /// Description of the task
  String _description;
  /// Task completion
  bool _isComplete;

  /*
      Constructors
  */

  /// For an object without an id
  TodoModel(this._title, this._description, this._isComplete);

  /// FOr an object with an id
  TodoModel.withId(this._id, this._title, this._description, this._isComplete);

  /*
      Getters
  */

  /// Gets the id of the task
  int get id {
    return this._id;
  }

  /// Gets the title of the task
  String get title {
    return this._title;
  }

  /// Gets the description of the task
  String get description {
    return this._description;
  }

  /// Gets the completion of the task
  bool get isComplete {
    return this._isComplete;
  }

  /*
      Setters
  */

  /// Sets the id of the task
  set id(int id) {
    this._id = id;
  }

  /// Sets the title of the task
  set title(String title) {
    this._title = title;
  }

  // Sets the description of the task
  set description(String description) {
    this._description = description;
  }

  /// Sets the completion of the task
  set isComplete(bool isComplete) {
    this._isComplete = isComplete;
  }

  /*
      Map Methods
  */

  /// Converts a task to a map, and returns the map
  Map<String, dynamic> toMap() {
    // Map for storing values
    Map<String, dynamic> _map = Map<String, dynamic>();
    // Only assign value if id is not null
    if (id != null) {
      _map["id"] = _id;
    }
    // Assign other values
    _map["title"] = _title;
    _map["description"] = _description;
    _map["isComplete"] = _isComplete;
    // Return the map
    return _map;
  }

  // Convert a Map object into a task
  TodoModel.fromMap(Map<String, dynamic> _map) {
    this._id = _map["id"];
    this._title = _map["title"];
    this._description = _map["description"];
    this._isComplete = _map["isComplete"];
  }
}