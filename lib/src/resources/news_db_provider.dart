import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';

final NewsDbProvider newsDbProvider = NewsDbProvider();

class NewsDbProvider implements Source, Cache {
  late Database db;
  final String tableName = 'itemtt';
  NewsDbProvider() {
    init();
  }
  init() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'items');
    db = await openDatabase(path, version: 1, onCreate: (Database newDb, int version) {
      newDb.execute("""
          CREATE TABLE $tableName
          (
            id INTEGER PRIMARY KEY,
            type TEXT,
            by TEXT,
            time INTEGER,
            text TEXT,
            parent INTEGER,
            kids BLOB,
            dead INTEGER,
            deleted INTEGER,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
          """);
    });
  }

  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      tableName,
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return ItemModel.fromDB(maps.first);
    } else {
      return ItemModel.fake();
    }
  }

  Future<int> addItem(ItemModel item) {
    return db.insert(tableName, item.toMap());
  }

  Future<List<int>> fetchTopIds() {
    var completer = new Completer<List<int>>();
    completer.complete([-10, -10, -10]);
    return completer.future;
  }

  Future<int> clear() {
    return db.delete(tableName);
  }
}
