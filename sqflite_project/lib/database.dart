import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoDatabase {
  Future<Database> createDB() async {
    Database db = await openDatabase(
      join(await getDatabasesPath(), "TodoDB.db"),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
CREATE TABLE Todo(
id INTEGER PRIMARY KEY AUTOINCREMENETED,
title TEXT,
description TEXT,
date TEXT
)

''');
      },
    );
    return db;
  }

  //get
  Future<List<Map>> getTodoItems() async {
    Database localDb = await createDB();
    List<Map> list = await localDb.query("Todo");
    return list;
  }

  //add data

  void insertTodoItem(Map<String, dynamic> obj) async {
    Database localdb = await createDB();
    await localdb.insert(
      "Todo",
      obj,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //update
  Future<void> updateTodoItem(Map<String, dynamic> obj) async {
    Database localdb = await createDB();
    await localdb.update("Todo", obj, where: "id=?", whereArgs: [obj['id']]);
  }
//dlt
  Future<void> deleteTodoItem(int index) async {
    Database localdb = await createDB();
    await localdb.delete("Todo",where: "id=?", whereArgs: [index]);
  }

  //
}
