/// Class representing a note
class Note {
  // Fields
  int _id;
  String _title;
  String _content;
  String _category;
  String _created;
  String _edited;

  // Constructor for object without an id
  Note(this._title, this._content, this._category, this._created,
      [this._edited]);

  // Constructor for object with an id
  Note.withId(
      this._id, this._title, this._content, this._category, this._created,
      [this._edited]);

  // Getter properties
  int get id {
    return _id;
  }

  String get title {
    return _title;
  }

  String get content {
    return _content;
  }

  String get category {
    return _category;
  }

  String get created {
    return _created;
  }

  String get edited {
    return _edited;
  }

  // Setter properties
  set id(int id) {
    this._id = id;
  }

  set title(String title) {
    this._title = title;
  }

  set content(String content) {
    this._content = content;
  }

  set category(String category) {
    this._category = category;
  }

  set created(String created) {
    this._created = created;
  }

  set edited(String edited) {
    this._edited = edited;
  }

  // Convert a note object into a Map object
  Map<String, dynamic> toMap() {
    // map for storing values
    Map<String, dynamic> _map = Map<String, dynamic>();
    // Only assign value if id is not null
    if (id != null) {
      _map['id'] = _id;
    }
    // Assign values
    _map['title'] = _title;
    _map['content'] = _content;
    _map['category'] = category;
    _map['created'] = _created;
    _map['edited'] = _edited;
    // Return the map
    return _map;
  }

  // Convert a Map object into a Note
  Note.fromMap(Map<String, dynamic> _map) {
    this._id = _map['id'];
    this._title = _map['title'];
    this._content = _map['content'];
    this._category = _map['category'];
    this._created = _map['created'];
    this._edited = _map['edited'];
  }
}
