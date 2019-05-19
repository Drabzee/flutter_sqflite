class Todo {
  int _id;
  String _item;
  String _date;

  Todo(this._item, this._date);

  int get id => _id;
  String get item => _item;
  String get date => _date;

  Todo.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._item = map['item'];
    this._date =  map['date'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    if(_id != null) map['id'] = _id;
    map['item'] = _item;
    map['date'] = _date;
    return map;
  }
}