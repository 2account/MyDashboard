/// Represents a product stored in the pantry
class Product {
  /// ID for the database
  int _id;

  /// Name of the product
  String _name;

  /// How many is there
  int _quantity;

  /// Whats the price
  double _price;

  /// When does it expire
  DateTime _bestBefore;

  /// European Article Number
  String _ean;

  // Constructor for creating an object without an id
  Product(this._name, this._quantity, this._price, this._bestBefore,
      [this._ean]);
  // Constructor for creating an object with an id
  Product.withId(
      this._id, this._name, this._quantity, this._price, this._bestBefore,
      [this._ean]);

  //
  // Object Getters
  //

  int get id {
    return this._id;
  }

  String get name {
    return this._name;
  }

  int get quantity {
    return this._quantity;
  }

  double get price {
    return this.price;
  }

  DateTime get bestBefore {
    return this._bestBefore;
  }

  String get ean {
    return this._ean;
  }

  //
  // Object setters
  //

  set id(int id) {
    this._id = id;
  }

  set name(String name) {
    this._name = name;
  }

  set quantity(int quantity) {
    this._quantity = quantity;
  }

  set price(double price) {
    this._price = price;
  }

  set bestBefore(DateTime bestBefore) {
    this._bestBefore = bestBefore;
  }

  set ean(String ean) {
    this._ean = ean;
  }

  //
  // Map Converting Functions
  //

  Map<String, dynamic> toMap() {
    // Map for storing values
    Map<String, dynamic> _map = Map<String, dynamic>();
    // Only assign value if id is not null
    if (id != null) {
      _map['id'] = _id;
    }
    // Assign other values
    _map["name"] = _name;
    _map["quantity"] = _quantity;
    _map["price"] = _price;
    _map["bestBefore"] = _bestBefore;
    _map["ean"] = _ean;
    // Return the map
    return _map;
  }
}
