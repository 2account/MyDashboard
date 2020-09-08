/// Model used for storing note data in the dashboard notes section
class NoteModel {
  /*
      Fields
  */

  /// The database id
  int _id;
  /// The title of the note
  String _title;
  /// The note itself
  String _content;
  /// The category of the note
  String _category;
  /// The time the note was created
  String _created;
  /// The time the note was last edited
  String _edited;

  /*
      Constructors
  */

  /// Constructor for notes without an id
  NoteModel(this._title, this._content, this._category, this._created,
      [this._edited]);

  /// Constructor for notes with an id
  NoteModel.withId(
      this._id, this._title, this._content, this._category, this._created,
      [this._edited]);

  /*
      Getters
  */

  /// Get the id of the note
  int get id {
    return _id;
  }

  /// Get the title of the note
  String get title {
    return _title;
  }

  /// Get the content of the note
  String get content {
    return _content;
  }

  /// Get the category of the note
  String get category {
    return _category;
  }

  /// Get the creation time of the note
  String get created {
    return _created;
  }

  /// Get the last time the note was edited
  String get edited {
    return _edited;
  }

  /*
      Setters
  */

  /// Set the id of the note
  set id(int id) {
    this._id = id;
  }

  /// Set the title of the note
  set title(String title) {
    this._title = title;
  }

  /// Set the content of the note
  set content(String content) {
    this._content = content;
  }

  /// Set the category of the note
  set category(String category) {
    this._category = category;
  }

  /// Set the creation time of the note
  set created(String created) {
    this._created = created;
  }

  /// Set the last time the note was edited
  set edited(String edited) {
    this._edited = edited;
  }

  /*
      Map Methods
  */

  /// Convert a note into a Map object
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

  /// Convert a Map object into a Note
  NoteModel.fromMap(Map<String, dynamic> _map) {
    this._id = _map['id'];
    this._title = _map['title'];
    this._content = _map['content'];
    this._category = _map['category'];
    this._created = _map['created'];
    this._edited = _map['edited'];
  }
}