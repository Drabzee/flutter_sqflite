import 'package:sqflite/sqflite.dart';
import '../models/todo_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';

class DatabaseHelper {

  final String dbName = 'todoDB';
  final int dbVersion = 1;
  final String tableName = 'todoTable';
  final String columnID = 'id';
  final String columnItem = 'item';
  final String columnDate = 'date';

  static final DatabaseHelper _instance = DatabaseHelper.internal();
  DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  Database _db;

  Future<Database> get db async {
    if(_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  initDB() async {
    Directory documentDirecory = await getApplicationDocumentsDirectory();
    String path = join(documentDirecory.path, dbName);
    Database ourDB = await openDatabase(path, version: dbVersion, onCreate: _onCreate);
    print('Databse opened successfully');
    return ourDB;
  }

  Future<void> _onCreate(Database db, int version) async {
    print('Table created successfully');
    await db.execute(
      'CREATE TABLE $tableName ('
        '$columnID INTEGER PRIMARY KEY,'
        '$columnItem TEXT,'
        '$columnDate TEXT'
      ');'
    );
  }

  //Save the todo in database
  Future<int> saveTodo(Todo todo) async {
    var dbClient = await db;
    int res = await dbClient.insert(tableName, todo.toMap());
    return res;
  }

  //Fetch all the todos from database
  Future<List> getAllTodos() async {
    var dbClient = await db;
    var todos = await dbClient.rawQuery(
      'SELECT * FROM $tableName;'
    );
    return todos.map((Map<String, dynamic> map) {
      return Todo.fromMap(map);
    }).toList();
  }

  //Get the count of todos in databse
  Future<int> getTodoCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
      await dbClient.rawQuery('SELECT COUNT(*) FROM $tableName;')
    );
  }

  //Fetch particular todo from database
  Future<Todo> getTodo(int id) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery(
      'SELECT * FROM $tableName WHERE $columnID=$id;'
    );
    return Todo.fromMap(res.first);
  }

  //Delete a particular todo from database
  Future<int> deleteTodo(int id) async {
    var dbClient = await db;
    var res = await dbClient.rawDelete(
      'DELETE FROM $tableName '
      'WHERE $columnID=$id;'
    );
    return res;
  }

  //Update a todo in database
  Future<int> updateTodo(String todo, int id) async {
    var dbClient = await db;
    var res = await dbClient.rawUpdate(
      'UPDATE $tableName SET $columnItem = "$todo" WHERE $columnID = $id;'
    );
    return res;
  }

  //Close the database
  Future<void> close() async {
    var dbClient = await db;
    print('Database closed successfully');
    return dbClient.close();
  }
}