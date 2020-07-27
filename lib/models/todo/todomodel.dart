class TodoModel {
  int _id;
  String _title;
  String _description;
  bool _isComplete;

  TodoModel(this._id, this._title, this._description, this._isComplete);

  int get id {
    return this._id;
  } 
  set id(int id) {
    this._id = id;
  }

  String get title {
    return this._title;
  } 
  set title(String title) {
    this._title = title;
  }

  String get description {
    return this._description;
  } 
  set description(String description) {
    this._description = description;
  }

  bool get isComplete {
    return this._isComplete;
  } 
  set isComplete(bool isComplete) {
    this._isComplete = isComplete;
  }

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
}