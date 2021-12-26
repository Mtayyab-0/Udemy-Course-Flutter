import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/item_model.dart';
import 'repository.dart';

final NewsDbHive newsDbHive = NewsDbHive();

class NewsDbHive implements Source, Cache {
  late Box box;
  NewsDbHive() {
    init();
  }
  init() async {
    Hive.initFlutter();
    box = await Hive.openBox('news');
  }

  addItem(ItemModel item) async {
    await box.put(item.id, item.toMap());
  }

  clear() async {
    await box.clear();
  }

  Future<ItemModel> fetchItem(int id) async {
    Map<String, dynamic> fromDB = (await box.get(id, defaultValue: ItemModel.fake().toMap()));
    return ItemModel.fromDB(fromDB);
  }

  Future<List<int>> fetchTopIds() {
    var completer = new Completer<List<int>>();
    completer.complete([-10, -10, -10]);
    return completer.future;
  }
}
